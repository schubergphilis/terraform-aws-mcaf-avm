locals {
  account_variable_set = {
    name = var.account_variable_set.name != null ? var.account_variable_set.name : "account-${var.name}"

    clear_text_terraform_variables = merge(
      var.account_variable_set.clear_text_terraform_variables,
      // always add account = var.name
      { account = var.name },
      // if environment, add environment = var.account.environment
      var.account.environment != null ? { environment = var.account.environment } : {},
      // if workload_boundary_arn, add workload_permissions_boundary_arn = aws_iam_policy.workload_boundary[0].arn
      var.permissions_boundaries.workload_boundary != null && var.permissions_boundaries.workload_boundary != null ? { workload_permissions_boundary_arn = aws_iam_policy.workload_boundary[0].arn } : {}
    )

    clear_text_env_variables = merge(
      var.account_variable_set.clear_text_env_variables,
      // Set the `DEFAULT_REGION` variable using the variable set. This way it is also applied to additional
      // workspaces unless that workspace sets the `region` field.
      { AWS_DEFAULT_REGION = var.tfe_workspace.default_region },
    )
  }

  tfe_workspace = {
    working_directory = var.account.environment != null ? "terraform/${var.account.environment}" : "terraform"
  }

  // create a list of auth_methods, and create the oidc provider if iam_role_oidc is in it
  // this allows for a mixture of auth_methods as they could differ per workspace.
  tfe_workspace_enable_oidc = contains(concat([var.tfe_workspace.auth_method], values(var.additional_tfe_workspaces)[*].auth_method), "iam_role_oidc")
}

################################################################################
# AWS Account & Settings
################################################################################

provider "aws" {
  alias  = "account"
  region = var.tfe_workspace.default_region

  default_tags {
    tags = var.tags
  }

  assume_role {
    role_arn = "arn:aws:iam::${module.account.id}:role/AWSControlTowerExecution"
  }
}

module "account" {
  source  = "schubergphilis/mcaf-account/aws"
  version = "~> 0.5.1"

  account                  = var.name
  email                    = var.account.email
  organizational_unit      = var.account.organizational_unit
  provisioned_product_name = var.account.provisioned_product_name
  sso_email                = var.account.sso_email
  sso_firstname            = var.account.sso_firstname
  sso_lastname             = var.account.sso_lastname
}

resource "aws_iam_account_alias" "alias" {
  provider      = aws.account
  account_alias = "${var.account.alias_prefix}${var.name}"
}

resource "aws_account_alternate_contact" "billing" {
  count    = var.account.contact_billing == null ? 0 : 1
  provider = aws.account

  alternate_contact_type = "BILLING"
  email_address          = var.account.contact_billing.email_address
  name                   = var.account.contact_billing.name
  phone_number           = var.account.contact_billing.phone_number
  title                  = var.account.contact_billing.title
}

resource "aws_account_alternate_contact" "operations" {
  count    = var.account.contact_operations == null ? 0 : 1
  provider = aws.account

  alternate_contact_type = "OPERATIONS"
  email_address          = var.account.contact_operations.email_address
  name                   = var.account.contact_operations.name
  phone_number           = var.account.contact_operations.phone_number
  title                  = var.account.contact_operations.title
}

resource "aws_account_alternate_contact" "security" {
  count    = var.account.contact_security == null ? 0 : 1
  provider = aws.account

  alternate_contact_type = "SECURITY"
  email_address          = var.account.contact_security.email_address
  name                   = var.account.contact_security.name
  phone_number           = var.account.contact_security.phone_number
  title                  = var.account.contact_security.title
}

data "tls_certificate" "oidc_certificate" {
  count = local.tfe_workspace_enable_oidc ? 1 : 0

  url = "https://app.terraform.io"
}

resource "aws_iam_openid_connect_provider" "tfc_provider" {
  count    = local.tfe_workspace_enable_oidc ? 1 : 0
  provider = aws.account

  url             = data.tls_certificate.oidc_certificate[0].url
  client_id_list  = ["aws.workload.identity"]
  thumbprint_list = [data.tls_certificate.oidc_certificate[0].certificates[0].sha1_fingerprint]
}

resource "aws_iam_policy" "workspace_boundary" {
  provider = aws.account
  count    = var.permissions_boundaries.workspace_boundary_name != null && var.permissions_boundaries.workspace_boundary != null ? 1 : 0
  name     = var.permissions_boundaries.workspace_boundary_name
  path     = var.path
  policy   = templatefile(var.permissions_boundaries.workspace_boundary, { account_id = module.account.id })
}

resource "aws_iam_policy" "workload_boundary" {
  provider = aws.account
  count    = var.permissions_boundaries.workload_boundary_name != null && var.permissions_boundaries.workload_boundary != null ? 1 : 0
  name     = var.permissions_boundaries.workload_boundary_name
  path     = var.path
  policy   = templatefile(var.permissions_boundaries.workload_boundary, { account_id = module.account.id })
}

################################################################################
# Terraform Cloud Variable Set
################################################################################

resource "tfe_variable_set" "account" {
  name         = local.account_variable_set.name
  description  = "Variable set for the account and all its linked workspaces"
  organization = var.tfe_workspace.organization
}

resource "tfe_variable" "account_variable_set_clear_text_env_variables" {
  for_each = local.account_variable_set.clear_text_env_variables

  key             = each.key
  value           = each.value
  category        = "env"
  variable_set_id = tfe_variable_set.account.id
}

resource "tfe_variable" "account_variable_set_clear_text_hcl_variables" {
  for_each = var.account_variable_set.clear_text_hcl_variables

  key             = each.key
  value           = each.value
  category        = "terraform"
  hcl             = true
  variable_set_id = tfe_variable_set.account.id
}

resource "tfe_variable" "account_variable_set_clear_text_terraform_variables" {
  for_each = local.account_variable_set.clear_text_terraform_variables

  key             = each.key
  value           = each.value
  category        = "terraform"
  variable_set_id = tfe_variable_set.account.id
}

################################################################################
# Terraform Cloud Workspace(s)
################################################################################

module "tfe_workspace" {
  count = var.create_default_workspace ? 1 : 0

  providers = { aws = aws.account }

  source  = "schubergphilis/mcaf-workspace/aws"
  version = "~> 2.3.0"

  agent_pool_id                  = var.tfe_workspace.agent_pool_id
  agent_role_arns                = var.tfe_workspace.agent_role_arns
  allow_destroy_plan             = var.tfe_workspace.allow_destroy_plan
  assessments_enabled            = var.tfe_workspace.assessments_enabled
  auth_method                    = var.tfe_workspace.auth_method
  auto_apply                     = var.tfe_workspace.auto_apply
  auto_apply_run_trigger         = var.tfe_workspace.auto_apply_run_trigger
  branch                         = var.tfe_workspace.connect_vcs_repo != false ? var.tfe_workspace.branch : null
  clear_text_env_variables       = var.tfe_workspace.clear_text_env_variables
  clear_text_hcl_variables       = var.tfe_workspace.clear_text_hcl_variables
  clear_text_terraform_variables = var.tfe_workspace.clear_text_terraform_variables
  description                    = var.tfe_workspace.description
  execution_mode                 = var.tfe_workspace.execution_mode
  file_triggers_enabled          = var.tfe_workspace.connect_vcs_repo != false ? var.tfe_workspace.file_triggers_enabled : null
  github_app_installation_id     = var.tfe_workspace.connect_vcs_repo != false ? var.tfe_workspace.vcs_github_app_installation_id : null
  global_remote_state            = var.tfe_workspace.global_remote_state
  name                           = coalesce(var.tfe_workspace.name, var.name)
  notification_configuration     = var.tfe_workspace.notification_configuration
  oauth_token_id                 = var.tfe_workspace.connect_vcs_repo != false ? var.tfe_workspace.vcs_oauth_token_id : null
  oidc_settings                  = var.tfe_workspace.auth_method == "iam_role_oidc" ? { provider_arn = aws_iam_openid_connect_provider.tfc_provider[0].arn } : null
  path                           = var.path
  permissions_boundary_arn       = var.tfe_workspace.add_permissions_boundary == true ? aws_iam_policy.workspace_boundary[0].arn : null
  policy                         = var.tfe_workspace.policy
  policy_arns                    = var.tfe_workspace.policy_arns
  project_id                     = var.tfe_workspace.project_id
  queue_all_runs                 = var.tfe_workspace.queue_all_runs
  remote_state_consumer_ids      = var.tfe_workspace.remote_state_consumer_ids
  repository_identifier          = var.tfe_workspace.connect_vcs_repo ? var.tfe_workspace.repository_identifier : null
  role_name                      = var.tfe_workspace.role_name
  sensitive_env_variables        = var.tfe_workspace.sensitive_env_variables
  sensitive_hcl_variables        = var.tfe_workspace.sensitive_hcl_variables
  sensitive_terraform_variables  = var.tfe_workspace.sensitive_terraform_variables
  speculative_enabled            = var.tfe_workspace.speculative_enabled
  ssh_key_id                     = var.tfe_workspace.ssh_key_id
  team_access                    = var.tfe_workspace.team_access
  terraform_organization         = var.tfe_workspace.organization
  terraform_version              = var.tfe_workspace.terraform_version
  trigger_patterns               = var.tfe_workspace.trigger_patterns
  trigger_prefixes               = var.tfe_workspace.connect_vcs_repo != false ? var.tfe_workspace.trigger_prefixes : null
  username                       = var.tfe_workspace.username
  variable_set_ids               = merge({ (local.account_variable_set.name) : tfe_variable_set.account.id }, var.tfe_workspace.variable_set_ids)
  working_directory              = coalesce(var.tfe_workspace.working_directory, local.tfe_workspace.working_directory)
  workspace_tags                 = var.tfe_workspace.workspace_tags
}

module "additional_tfe_workspaces" {
  for_each = var.additional_tfe_workspaces

  providers = { aws = aws.account }

  source  = "schubergphilis/mcaf-workspace/aws"
  version = "~> 2.3.0"

  agent_pool_id                  = each.value.agent_pool_id != null ? each.value.agent_pool_id : var.tfe_workspace.agent_pool_id
  agent_role_arns                = each.value.agent_role_arns != null ? each.value.agent_role_arns : var.tfe_workspace.agent_role_arns
  allow_destroy_plan             = each.value.allow_destroy_plan != null ? each.value.allow_destroy_plan : var.tfe_workspace.allow_destroy_plan
  assessments_enabled            = each.value.assessments_enabled != null ? each.value.assessments_enabled : var.tfe_workspace.assessments_enabled
  auth_method                    = each.value.auth_method != null ? each.value.auth_method : var.tfe_workspace.auth_method
  auto_apply                     = each.value.auto_apply
  auto_apply_run_trigger         = each.value.auto_apply_run_trigger
  branch                         = each.value.connect_vcs_repo != false ? coalesce(each.value.branch, var.tfe_workspace.branch) : null
  clear_text_env_variables       = each.value.clear_text_env_variables
  clear_text_hcl_variables       = each.value.clear_text_hcl_variables
  clear_text_terraform_variables = each.value.clear_text_terraform_variables
  description                    = each.value.description
  execution_mode                 = coalesce(each.value.execution_mode, var.tfe_workspace.execution_mode)
  file_triggers_enabled          = each.value.connect_vcs_repo != false ? each.value.file_triggers_enabled : null
  github_app_installation_id     = each.value.connect_vcs_repo != false ? try(coalesce(each.value.vcs_github_app_installation_id, var.tfe_workspace.vcs_github_app_installation_id), null) : null
  global_remote_state            = each.value.global_remote_state
  name                           = coalesce(each.value.name, each.key)
  notification_configuration     = each.value.notification_configuration != null ? each.value.notification_configuration : var.tfe_workspace.notification_configuration
  oauth_token_id                 = each.value.connect_vcs_repo != false ? try(coalesce(each.value.vcs_oauth_token_id, var.tfe_workspace.vcs_oauth_token_id), null) : null
  oidc_settings                  = coalesce(each.value.auth_method, var.tfe_workspace.auth_method) == "iam_role_oidc" ? { provider_arn = aws_iam_openid_connect_provider.tfc_provider[0].arn } : null
  path                           = var.path
  permissions_boundary_arn       = each.value.add_permissions_boundary == true ? aws_iam_policy.workspace_boundary[0].arn : null
  policy                         = each.value.policy
  policy_arns                    = each.value.policy_arns
  project_id                     = each.value.project_id != null ? each.value.project_id : var.tfe_workspace.project_id
  queue_all_runs                 = each.value.queue_all_runs
  region                         = each.value.default_region
  remote_state_consumer_ids      = each.value.remote_state_consumer_ids
  repository_identifier          = each.value.connect_vcs_repo != false ? coalesce(each.value.repository_identifier, var.tfe_workspace.repository_identifier) : null
  role_name                      = coalesce(each.value.role_name, "TFEPipeline${replace(title(each.key), "/[_-]/", "")}")
  sensitive_env_variables        = each.value.sensitive_env_variables
  sensitive_hcl_variables        = each.value.sensitive_hcl_variables
  sensitive_terraform_variables  = each.value.sensitive_terraform_variables
  speculative_enabled            = each.value.speculative_enabled
  ssh_key_id                     = each.value.ssh_key_id != null ? each.value.ssh_key_id : var.tfe_workspace.ssh_key_id
  team_access                    = each.value.team_access != null ? each.value.team_access : var.tfe_workspace.team_access
  terraform_organization         = var.tfe_workspace.organization
  terraform_version              = each.value.terraform_version != null ? each.value.terraform_version : var.tfe_workspace.terraform_version
  trigger_patterns               = each.value.trigger_patterns != null ? each.value.trigger_patterns : var.tfe_workspace.trigger_patterns
  trigger_prefixes               = each.value.connect_vcs_repo != false ? coalesce(each.value.trigger_prefixes, var.tfe_workspace.trigger_prefixes) : null
  username                       = coalesce(each.value.username, "TFEPipeline-${each.key}")
  variable_set_ids               = merge({ (local.account_variable_set.name) : tfe_variable_set.account.id }, each.value.variable_set_ids)
  working_directory              = coalesce(each.value.working_directory, "terraform/${coalesce(each.value.name, each.key)}")
  workspace_tags                 = each.value.workspace_tags
}
