locals {
  tfe_workspace = {
    clear_text_terraform_variables = var.account.environment != null ? {
      account = var.name, environment = var.account.environment } : {
      account = var.name
    }

    working_directory = var.account.environment != null ? "terraform/${var.account.environment}" : "terraform"
  }
}

provider "aws" {
  alias  = "account"
  region = var.tfe_workspace.default_region

  assume_role {
    role_arn = "arn:aws:iam::${module.account.id}:role/AWSControlTowerExecution"
  }
}

module "account" {
  source = "github.com/schubergphilis/terraform-aws-mcaf-account?ref=v0.5.1"

  account                  = var.name
  email                    = var.account.email
  organizational_unit      = var.account.organizational_unit
  provisioned_product_name = var.account.provisioned_product_name
  sso_email                = var.account.sso_email
  sso_firstname            = var.account.sso_firstname
  sso_lastname             = var.account.sso_lastname
}

resource "aws_iam_policy" "pipeline_boundary" {
  provider   = aws.account
  count      = var.permission_boundaries.pipeline_boundary_name != null ? 1 : 0
  name       = var.permission_boundaries.pipeline_boundary_name
  policy     = templatefile(var.permission_boundaries.pipeline_boundary, { account_id = module.account.id })
}

resource "aws_iam_policy" "workload_boundary" {
  provider   = aws.account
  count      = var.permission_boundaries.workload_boundary_name != null ? 1 : 0
  name       = var.permission_boundaries.workload_boundary_name
  policy     = templatefile(var.permission_boundaries.workload_boundary, { account_id = module.account.id })
}

module "tfe_workspace" {
  count = var.create_default_workspace ? 1 : 0
  source    = "github.com/schubergphilis/terraform-aws-mcaf-workspace?ref=v0.10.0"
  providers = { aws = aws.account }

  agent_pool_id                  = var.tfe_workspace.agent_pool_id
  agent_role_arn                 = var.tfe_workspace.agent_role_arn
  auth_method                    = var.tfe_workspace.auth_method
  auto_apply                     = var.tfe_workspace.auto_apply
  branch                         = var.tfe_workspace.branch
  clear_text_env_variables       = var.tfe_workspace.clear_text_env_variables
  clear_text_hcl_variables       = var.tfe_workspace.clear_text_hcl_variables
  clear_text_terraform_variables = merge(local.tfe_workspace.clear_text_terraform_variables, var.tfe_workspace.clear_text_terraform_variables)
  execution_mode                 = var.tfe_workspace.execution_mode
  file_triggers_enabled          = var.tfe_workspace.file_triggers_enabled
  global_remote_state            = var.tfe_workspace.global_remote_state
  name                           = coalesce(var.tfe_workspace.name, var.name)
  oauth_token_id                 = var.tfe_workspace.vcs_oauth_token_id
  permissions_boundary_arn       = aws_iam_policy.pipeline_boundary[0].arn
  policy                         = var.tfe_workspace.policy
  policy_arns                    = var.tfe_workspace.policy_arns
  region                         = var.tfe_workspace.default_region
  remote_state_consumer_ids      = var.tfe_workspace.remote_state_consumer_ids
  repository_identifier          = var.tfe_workspace.repository_identifier
  role_name                      = var.tfe_workspace.role_name
  sensitive_env_variables        = var.tfe_workspace.sensitive_env_variables
  sensitive_hcl_variables        = var.tfe_workspace.sensitive_hcl_variables
  sensitive_terraform_variables  = var.tfe_workspace.sensitive_terraform_variables
  slack_notification_triggers    = var.tfe_workspace.slack_notification_triggers
  slack_notification_url         = var.tfe_workspace.slack_notification_url
  ssh_key_id                     = var.tfe_workspace.ssh_key_id
  tags                           = var.tags
  team_access                    = var.tfe_workspace.team_access
  terraform_organization         = var.tfe_workspace.organization
  terraform_version              = var.tfe_workspace.terraform_version
  trigger_prefixes               = var.tfe_workspace.trigger_prefixes
  username                       = var.tfe_workspace.username
  working_directory              = var.tfe_workspace.working_directory != null ? var.tfe_workspace.working_directory : local.tfe_workspace.working_directory
}

module "additional_tfe_workspaces" {
  for_each = var.additional_tfe_workspaces
  source    = "github.com/schubergphilis/terraform-aws-mcaf-workspace?ref=v0.10.0"
  providers = { aws = aws.account }

  agent_pool_id                  = each.value.agent_pool_id != null ? each.value.agent_pool_id : var.tfe_workspace.agent_pool_id
  agent_role_arn                 = each.value.agent_role_arn != null ? each.value.agent_role_arn : var.tfe_workspace.agent_role_arn
  auth_method                    = each.value.auth_method != null ? each.value.auth_method : var.tfe_workspace.auth_method
  auto_apply                     = each.value.auto_apply
  branch                         = coalesce(each.value.branch, var.tfe_workspace.branch)
  clear_text_env_variables       = each.value.clear_text_env_variables
  clear_text_hcl_variables       = each.value.clear_text_hcl_variables
  clear_text_terraform_variables = merge(local.tfe_workspace.clear_text_terraform_variables, each.value.clear_text_terraform_variables)
  execution_mode                 = coalesce(each.value.execution_mode, var.tfe_workspace.execution_mode)
  file_triggers_enabled          = each.value.file_triggers_enabled
  global_remote_state            = each.value.global_remote_state
  name                           = coalesce(each.value.name, each.key)
  oauth_token_id                 = coalesce(each.value.vcs_oauth_token_id, var.tfe_workspace.vcs_oauth_token_id)
  permissions_boundary_arn       = aws_iam_policy.pipeline_boundary[0].arn
  policy                         = each.value.policy
  policy_arns                    = each.value.policy_arns
  region                         = coalesce(each.value.default_region, var.tfe_workspace.default_region)
  remote_state_consumer_ids      = each.value.remote_state_consumer_ids
  repository_identifier          = coalesce(each.value.repository_identifier, var.tfe_workspace.repository_identifier)
  role_name                      = coalesce(each.value.role_name, "TFEPipeline${replace(title(each.key), "/[_-]/", "")}")
  sensitive_env_variables        = each.value.sensitive_env_variables
  sensitive_hcl_variables        = each.value.sensitive_hcl_variables
  sensitive_terraform_variables  = each.value.sensitive_terraform_variables
  slack_notification_triggers    = coalesce(each.value.slack_notification_triggers, var.tfe_workspace.slack_notification_triggers)
  slack_notification_url         = each.value.slack_notification_url != null ? each.value.slack_notification_url : var.tfe_workspace.slack_notification_url
  ssh_key_id                     = each.value.ssh_key_id != null ? each.value.ssh_key_id : var.tfe_workspace.ssh_key_id
  tags                           = var.tags
  team_access                    = each.value.team_access != {} ? each.value.team_access : var.tfe_workspace.team_access
  terraform_organization         = var.tfe_workspace.organization
  terraform_version              = each.value.terraform_version != null ? each.value.terraform_version : var.tfe_workspace.terraform_version
  trigger_prefixes               = coalesce(each.value.trigger_prefixes, var.tfe_workspace.trigger_prefixes)
  username                       = coalesce(each.value.username, "TFEPipeline-${each.key}")
  working_directory              = coalesce(each.value.working_directory, "terraform/${coalesce(each.value.name, each.key)}")
}

resource "aws_iam_account_alias" "alias" {
  provider      = aws.account
  account_alias = "${var.account.alias_prefix}${var.name}"
}

