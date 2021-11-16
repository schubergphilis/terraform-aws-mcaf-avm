variable "account_settings" {
  type = object({
    alias_prefix         = string
    create_email_address = string
    email                = string
    environment          = string
    organizational_unit  = string
    sso_email            = string
    sso_firstname        = string
    sso_lastname         = string
  })
  description = "Account settings"
}

variable "additional_tfe_workspaces" {
  type = map(object({
    agent_pool_id                  = string
    auto_apply                     = bool
    branch                         = string
    clear_text_env_variables       = map(string)
    clear_text_hcl_variables       = map(string)
    clear_text_terraform_variables = map(string)
    execution_mode                 = string
    file_triggers_enabled          = bool
    global_remote_state            = bool
    oauth_token_id                 = string
    policy                         = string
    policy_arns                    = list(string)
    remote_state_consumer_ids      = set(string)
    repository_identifier          = string
    sensitive_env_variables        = map(string)
    sensitive_hcl_variables        = map(object({ sensitive = string }))
    sensitive_terraform_variables  = map(string)
    slack_notification_triggers    = list(string)
    slack_notification_url         = string
    ssh_key_id                     = string
    terraform_organization         = string
    terraform_version              = string
    trigger_prefixes               = list(string)
    username                       = string
    working_directory              = string
  }))
  default     = {}
  description = "Additional TFE Workspaces"
}

variable "name" {
  type        = string
  description = "Name of the account"
}

variable "region" {
  type        = string
  default     = "eu-west-1"
  description = "The default region of the account"
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to resource"
}

variable "tfe_workspace_agent_pool_id" {
  type        = string
  default     = null
  description = "Agent pool ID"
}

variable "tfe_workspace_auto_apply" {
  type        = bool
  default     = false
  description = "Whether to automatically apply changes when a Terraform plan is successful"
}

variable "tfe_workspace_branch" {
  type        = string
  default     = "master"
  description = "The Git branch to trigger the TFE workspace for"
}

variable "tfe_workspace_clear_text_env_variables" {
  type        = map(string)
  default     = {}
  description = "An optional map with clear text environment variables"
}

variable "tfe_workspace_clear_text_hcl_variables" {
  type        = map(string)
  default     = {}
  description = "An optional map with clear text HCL Terraform variables"
}

variable "tfe_workspace_clear_text_terraform_variables" {
  type        = map(string)
  default     = {}
  description = "An optional map with clear text Terraform variables"
}

variable "tfe_workspace_execution_mode" {
  type        = string
  default     = "remote"
  description = "Which TFE workspace execution mode to use"
}

variable "tfe_workspace_file_triggers_enabled" {
  type        = bool
  default     = true
  description = "Whether to filter runs based on the changed files in a VCS push"
}

variable "tfe_workspace_name" {
  type        = string
  default     = null
  description = "Custom workspace name (overrides var.name)"
}

variable "tfe_workspace_policy" {
  type        = string
  default     = null
  description = "The policy to attach to the pipeline user"
}

variable "tfe_workspace_policy_arns" {
  type        = list(string)
  default     = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  description = "A set of policy ARNs to attach to the pipeline user"
}

variable "tfe_workspace_sensitive_env_variables" {
  type        = map(string)
  default     = {}
  description = "An optional map with sensitive environment variables"
}

variable "tfe_workspace_sensitive_hcl_variables" {
  type = map(object({
    sensitive = string
  }))
  default     = {}
  description = "An optional map with sensitive HCL Terraform variables"
}

variable "tfe_workspace_sensitive_terraform_variables" {
  type        = map(string)
  default     = {}
  description = "An optional map with sensitive Terraform variables"
}

variable "tfe_workspace_settings" {
  type = object({
    global_remote_state       = bool
    oauth_token_id            = string
    remote_state_consumer_ids = set(string)
    repository_identifier     = string
    terraform_organization    = string
    terraform_version         = string
    working_directory         = string
  })
  default     = null
  description = "TFE Workspaces settings"
}

variable "tfe_workspace_slack_notification_triggers" {
  type = list(string)
  default = [
    "run:created",
    "run:planning",
    "run:needs_attention",
    "run:applying",
    "run:completed",
    "run:errored"
  ]
  description = "The triggers to send to Slack"
}

variable "tfe_workspace_slack_notification_url" {
  type        = string
  default     = null
  description = "The Slack Webhook URL to send notification to"
}

variable "tfe_workspace_ssh_key_id" {
  type        = string
  default     = null
  description = "The SSH key ID to assign to the workspace"
}

variable "tfe_workspace_trigger_prefixes" {
  type        = list(string)
  default     = ["modules"]
  description = "List of repository-root-relative paths which should be tracked for changes"
}
