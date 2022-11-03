variable "account_settings" {
  type = object({
    alias_prefix        = string
    email               = string
    environment         = string
    organizational_unit = string
    sso_email           = string
    sso_firstname       = optional(string, "AWS Control Tower")
    sso_lastname        = optional(string, "Admin")
  })
  description = "Account settings"
}

variable "additional_tfe_workspaces" {
  type = map(object({
    agent_pool_id                  = optional(string, null)
    auto_apply                     = optional(bool, false)
    branch                         = optional(string, "main")
    clear_text_env_variables       = optional(map(string), {})
    clear_text_hcl_variables       = optional(map(string), {})
    clear_text_terraform_variables = optional(map(string), {})
    execution_mode                 = optional(string, "remote")
    file_triggers_enabled          = optional(bool, true)
    global_remote_state            = optional(bool, false)
    oauth_token_id                 = string
    policy                         = optional(string, null)
    policy_arns                    = optional(list(string), ["arn:aws:iam::aws:policy/AdministratorAccess"])
    remote_state_consumer_ids      = optional(set(string))
    repository_identifier          = string
    sensitive_env_variables        = optional(map(string), {})
    sensitive_hcl_variables        = optional(map(object({ sensitive = string })), {})
    sensitive_terraform_variables  = optional(map(string), {})
    slack_notification_triggers    = optional(list(string), ["run:created", "run:planning", "run:needs_attention", "run:applying", "run:completed", "run:errored"])
    slack_notification_url         = optional(string, null)
    ssh_key_id                     = optional(string, null)
    team_access                    = optional(map(object({ access = string, team_id = string, })), {})
    terraform_organization         = string
    terraform_version              = optional(string, null)
    trigger_prefixes               = optional(list(string), ["modules"])
    username                       = optional(string, null)
    working_directory              = optional(string, "terraform")
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
  default     = "main"
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
    global_remote_state       = optional(bool, false)
    oauth_token_id            = string
    remote_state_consumer_ids = optional(set(string))
    repository_identifier     = string
    terraform_organization    = string
    terraform_version         = optional(string, null)
    working_directory         = optional(string, "terraform")
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

variable "tfe_workspace_team_access" {
  type = map(object({
    access  = string,
    team_id = string,
  }))
  default     = {}
  description = "An optional map with team IDs and workspace access permissions to assign"
}

variable "tfe_workspace_trigger_prefixes" {
  type        = list(string)
  default     = ["modules"]
  description = "List of repository-root-relative paths which should be tracked for changes"
}
