variable "account" {
  type = object({
    alias_prefix             = optional(string, null)
    email                    = string
    environment              = optional(string, null)
    organizational_unit      = string
    provisioned_product_name = optional(string, null)
    sso_email                = string
    sso_firstname            = optional(string, "AWS Control Tower")
    sso_lastname             = optional(string, "Admin")
  })
  description = "AWS account settings"
}

variable "additional_tfe_workspaces" {
  type = map(object({
    agent_pool_id                  = optional(string, null)
    agent_role_arn                 = optional(string, null)
    auth_method                    = optional(string, null)
    auto_apply                     = optional(bool, false)
    # boundary_auth_method           = optional(bool, false)
    branch                         = optional(string, null)
    clear_text_env_variables       = optional(map(string), {})
    clear_text_hcl_variables       = optional(map(string), {})
    clear_text_terraform_variables = optional(map(string), {})
    default_region                 = optional(string, null)
    execution_mode                 = optional(string, null)
    file_triggers_enabled          = optional(bool, true)
    global_remote_state            = optional(bool, false)
    name                           = optional(string, null)
    # permissions_boundary           = optional(string, null)
    # permissions_boundary_name      = optional(string, null)
    permissions_boundary_arn       = optional(string, null) 
    policy                         = optional(string, null)
    policy_arns                    = optional(list(string), ["arn:aws:iam::aws:policy/AdministratorAccess"])
    remote_state_consumer_ids      = optional(set(string))
    repository_identifier          = optional(string, null)
    role_name                      = optional(string, null)
    sensitive_env_variables        = optional(map(string), {})
    sensitive_hcl_variables        = optional(map(object({ sensitive = string })), {})
    sensitive_terraform_variables  = optional(map(string), {})
    slack_notification_triggers    = optional(list(string), null)
    slack_notification_url         = optional(string, null)
    ssh_key_id                     = optional(string, null)
    terraform_version              = optional(string, null)
    trigger_prefixes               = optional(list(string), null)
    username                       = optional(string, null)
    vcs_oauth_token_id             = optional(string, null)
    working_directory              = optional(string, null)
    # workload_boundary              = optional(string, null)
    # workload_boundary_name         = optional(string, null)

    team_access = optional(map(object({
      access = optional(string, null),
      permissions = optional(object({
        run_tasks         = bool
        runs              = string
        sentinel_mocks    = string
        state_versions    = string
        variables         = string
        workspace_locking = bool
      }), null)
    })), {})
  }))
  default     = {}
  description = "Additional TFE workspaces"
}

variable "create_default_workspace" {
  type        = bool
  default     = true
  description = "Set to false to skip creating default workspace"
}

variable "name" {
  type        = string
  description = "Name of the account and default TFE workspace"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to all resources"
}

variable "permission_boundaries" {
 type = object({ 
    boundary_auth_method   = optional(bool, false)
    pipeline_boundary      = optional(string, null)
    pipeline_boundary_name = optional(string, null)
    workload_boundary      = optional(string, null)
    workload_boundary_name = optional(string, null)
 })
}

variable "tfe_workspace" {
  type = object({
    agent_pool_id                  = optional(string, null)
    agent_role_arn                 = optional(string, null)
    auth_method                    = optional(string, "iam_user")
    auto_apply                     = optional(bool, false)
    boundary_auth_method           = optional(bool, false)
    branch                         = optional(string, "main")
    clear_text_env_variables       = optional(map(string), {})
    clear_text_hcl_variables       = optional(map(string), {})
    clear_text_terraform_variables = optional(map(string), {})
    default_region                 = string
    execution_mode                 = optional(string, "remote")
    file_triggers_enabled          = optional(bool, true)
    global_remote_state            = optional(bool, false)
    name                           = optional(string, null)
    permissions_boundary_arn       = optional(string, null)
    policy                         = optional(string, null)
    policy_arns                    = optional(list(string), ["arn:aws:iam::aws:policy/AdministratorAccess"])
    remote_state_consumer_ids      = optional(set(string))
    repository_identifier          = string
    role_name                      = optional(string, "TFEPipeline")
    sensitive_env_variables        = optional(map(string), {})
    sensitive_hcl_variables        = optional(map(object({ sensitive = string })), {})
    sensitive_terraform_variables  = optional(map(string), {})
    slack_notification_triggers    = optional(list(string), ["run:created", "run:planning", "run:needs_attention", "run:applying", "run:completed", "run:errored"])
    slack_notification_url         = optional(string, null)
    ssh_key_id                     = optional(string, null)
    organization                   = string
    terraform_version              = optional(string, null)
    trigger_prefixes               = optional(list(string), ["modules"])
    username                       = optional(string, "TFEPipeline")
    vcs_oauth_token_id             = string
    working_directory              = optional(string, null)

    team_access = optional(map(object({
      access = optional(string, null),
      permissions = optional(object({
        run_tasks         = bool
        runs              = string
        sentinel_mocks    = string
        state_versions    = string
        variables         = string
        workspace_locking = bool
      }), null)
    })), {})
  })
  description = "TFE workspace settings"
}
