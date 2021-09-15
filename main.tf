provider "aws" {
  alias  = "account"
  region = var.region

  assume_role {
    role_arn = "arn:aws:iam::${module.account.id}:role/AWSControlTowerExecution"
  }
}

module "account" {
  source = "github.com/schubergphilis/terraform-aws-mcaf-account?ref=v0.3.0"

  account             = var.name
  email               = var.account_settings.email
  organizational_unit = var.account_settings.organizational_unit
  sso_email           = var.account_settings.sso_email
  sso_firstname       = var.account_settings.sso_firstname
  sso_lastname        = var.account_settings.sso_lastname
}

module "tfe_workspace" {
  count                          = var.tfe_workspace_settings != null ? 1 : 0
  source                         = "github.com/schubergphilis/terraform-aws-mcaf-workspace?ref=v0.5.2"
  providers                      = { aws = aws.account }
  name                           = coalesce(var.tfe_workspace_name, var.name)
  auto_apply                     = var.tfe_workspace_auto_apply
  branch                         = var.tfe_workspace_branch
  clear_text_env_variables       = var.tfe_workspace_clear_text_env_variables
  clear_text_hcl_variables       = var.tfe_workspace_clear_text_hcl_variables
  clear_text_terraform_variables = var.tfe_workspace_clear_text_terraform_variables
  file_triggers_enabled          = var.tfe_workspace_file_triggers_enabled
  kms_key_id                     = var.tfe_workspace_kms_key_id
  oauth_token_id                 = var.tfe_workspace_settings.oauth_token_id
  policy                         = var.tfe_workspace_policy
  policy_arns                    = var.tfe_workspace_policy_arns
  region                         = var.region
  repository_name                = var.tfe_workspace_settings.repository_name
  repository_owner               = var.tfe_workspace_settings.repository_owner
  sensitive_env_variables        = var.tfe_workspace_sensitive_env_variables
  sensitive_hcl_variables        = var.tfe_workspace_sensitive_hcl_variables
  sensitive_terraform_variables  = var.tfe_workspace_sensitive_terraform_variables
  slack_notification_triggers    = var.tfe_workspace_slack_notification_triggers
  slack_notification_url         = var.tfe_workspace_slack_notification_url
  ssh_key_id                     = var.tfe_workspace_ssh_key_id
  terraform_organization         = var.tfe_workspace_settings.terraform_organization
  terraform_version              = var.tfe_workspace_settings.terraform_version
  tfe_agent_pool_id              = var.tfe_workspace_agent_pool_id
  trigger_prefixes               = var.tfe_workspace_trigger_prefixes
  username                       = "TFEPipeline"
  working_directory              = var.account_settings.environment != null ? "terraform/${var.account_settings.environment}" : "terraform"
  tags                           = var.tags
}

module "additional_tfe_workspaces" {
  for_each = var.additional_tfe_workspaces

  source                        = "github.com/schubergphilis/terraform-aws-mcaf-workspace?ref=v0.5.2"
  providers                     = { aws = aws.account }
  name                          = each.key
  auto_apply                    = each.value.auto_apply
  branch                        = each.value.branch
  clear_text_env_variables      = each.value.clear_text_env_variables
  clear_text_hcl_variables      = each.value.clear_text_hcl_variables
  file_triggers_enabled         = each.value.file_triggers_enabled
  kms_key_id                    = each.value.kms_key_id
  oauth_token_id                = each.value.oauth_token_id
  policy                        = each.value.policy
  policy_arns                   = each.value.policy_arns
  region                        = var.region
  repository_name               = each.value.repository_name
  repository_owner              = each.value.repository_owner
  sensitive_env_variables       = each.value.sensitive_env_variables
  sensitive_hcl_variables       = each.value.sensitive_hcl_variables
  sensitive_terraform_variables = each.value.sensitive_terraform_variables
  slack_notification_triggers   = each.value.slack_notification_triggers
  slack_notification_url        = each.value.slack_notification_url
  ssh_key_id                    = each.value.ssh_key_id
  terraform_organization        = each.value.terraform_organization
  terraform_version             = each.value.terraform_version
  tfe_agent_pool_id             = each.value.agent_pool_id
  trigger_prefixes              = each.value.trigger_prefixes
  username                      = coalesce(each.value.username, "TFEPipeline-${each.key}")
  working_directory             = each.value.working_directory
  tags                          = var.tags

  clear_text_terraform_variables = merge({
    account     = var.name
    environment = var.account_settings.environment
  }, each.value.clear_text_terraform_variables)
}

resource "aws_iam_account_alias" "alias" {
  provider      = aws.account
  account_alias = "${try(var.account_settings.alias_prefix, "")}${var.name}"
}
