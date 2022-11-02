provider "aws" {
  alias  = "account"
  region = var.region

  assume_role {
    role_arn = "arn:aws:iam::${module.account.id}:role/AWSControlTowerExecution"
  }
}

module "account" {
  source              = "github.com/schubergphilis/terraform-aws-mcaf-account?ref=v0.5.0"
  account             = var.name
  email               = var.account_settings.email
  organizational_unit = var.account_settings.organizational_unit
  sso_email           = var.account_settings.sso_email
  sso_firstname       = var.account_settings.sso_firstname
  sso_lastname        = var.account_settings.sso_lastname
}

module "tfe_workspace" {
  count     = var.tfe_workspace_settings != null ? 1 : 0
  source    = "github.com/schubergphilis/terraform-aws-mcaf-workspace?ref=v0.8.1"
  providers = { aws = aws.account }

  agent_pool_id                 = var.tfe_workspace_agent_pool_id
  auto_apply                    = var.tfe_workspace_auto_apply
  branch                        = var.tfe_workspace_branch
  clear_text_env_variables      = var.tfe_workspace_clear_text_env_variables
  clear_text_hcl_variables      = var.tfe_workspace_clear_text_hcl_variables
  execution_mode                = var.tfe_workspace_execution_mode
  file_triggers_enabled         = var.tfe_workspace_file_triggers_enabled
  global_remote_state           = var.tfe_workspace_settings.global_remote_state
  name                          = coalesce(var.tfe_workspace_name, var.name)
  oauth_token_id                = var.tfe_workspace_settings.oauth_token_id
  policy                        = var.tfe_workspace_policy
  policy_arns                   = var.tfe_workspace_policy_arns
  region                        = var.region
  remote_state_consumer_ids     = var.tfe_workspace_settings.remote_state_consumer_ids
  repository_identifier         = var.tfe_workspace_settings.repository_identifier
  sensitive_env_variables       = var.tfe_workspace_sensitive_env_variables
  sensitive_hcl_variables       = var.tfe_workspace_sensitive_hcl_variables
  sensitive_terraform_variables = var.tfe_workspace_sensitive_terraform_variables
  slack_notification_triggers   = var.tfe_workspace_slack_notification_triggers
  slack_notification_url        = var.tfe_workspace_slack_notification_url
  ssh_key_id                    = var.tfe_workspace_ssh_key_id
  tags                          = var.tags
  team_access                   = var.tfe_workspace_team_access
  terraform_organization        = var.tfe_workspace_settings.terraform_organization
  terraform_version             = var.tfe_workspace_settings.terraform_version
  trigger_prefixes              = var.tfe_workspace_trigger_prefixes
  username                      = "TFEPipeline"

  clear_text_terraform_variables = merge({
    account     = var.name
    environment = var.account_settings.environment
  }, var.tfe_workspace_clear_text_terraform_variables)

  working_directory = (
    var.tfe_workspace_settings.working_directory != null ?
    var.tfe_workspace_settings.working_directory :
    var.account_settings.environment != null ? "terraform/${var.account_settings.environment}" : "terraform"
  )
}

module "additional_tfe_workspaces" {
  for_each  = var.additional_tfe_workspaces
  source    = "github.com/schubergphilis/terraform-aws-mcaf-workspace?ref=v0.8.1"
  providers = { aws = aws.account }

  agent_pool_id                 = each.value.agent_pool_id
  auto_apply                    = each.value.auto_apply
  branch                        = each.value.branch
  clear_text_env_variables      = each.value.clear_text_env_variables
  clear_text_hcl_variables      = each.value.clear_text_hcl_variables
  execution_mode                = each.value.execution_mode
  file_triggers_enabled         = each.value.file_triggers_enabled
  global_remote_state           = each.value.global_remote_state
  name                          = each.key
  oauth_token_id                = each.value.oauth_token_id
  policy                        = each.value.policy
  policy_arns                   = each.value.policy_arns
  region                        = var.region
  remote_state_consumer_ids     = each.value.remote_state_consumer_ids
  repository_identifier         = each.value.repository_identifier
  sensitive_env_variables       = each.value.sensitive_env_variables
  sensitive_hcl_variables       = each.value.sensitive_hcl_variables
  sensitive_terraform_variables = each.value.sensitive_terraform_variables
  slack_notification_triggers   = each.value.slack_notification_triggers
  slack_notification_url        = each.value.slack_notification_url
  ssh_key_id                    = each.value.ssh_key_id
  tags                          = var.tags
  team_access                   = each.value.team_access
  terraform_organization        = each.value.terraform_organization
  terraform_version             = each.value.terraform_version
  trigger_prefixes              = each.value.trigger_prefixes
  username                      = coalesce(each.value.username, "TFEPipeline-${each.key}")
  working_directory             = each.value.working_directory

  clear_text_terraform_variables = merge({
    account     = var.name
    environment = var.account_settings.environment
  }, each.value.clear_text_terraform_variables)
}

resource "aws_iam_account_alias" "alias" {
  provider      = aws.account
  account_alias = "${try(var.account_settings.alias_prefix, "")}${var.name}"
}
