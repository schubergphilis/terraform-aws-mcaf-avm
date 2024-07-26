variable "account" {
  type = object({
    alias_prefix = optional(string)
    contact_billing = optional(object({
      email_address = string
      name          = string
      phone_number  = string
      title         = string
    }), null)
    contact_operations = optional(object({
      email_address = string
      name          = string
      phone_number  = string
      title         = string
    }), null)
    contact_security = optional(object({
      email_address = string
      name          = string
      phone_number  = string
      title         = string
    }), null)
    email                    = string
    environment              = optional(string)
    organizational_unit      = string
    provisioned_product_name = optional(string)
    sso_email                = string
    sso_firstname            = optional(string, "AWS Control Tower")
    sso_lastname             = optional(string, "Admin")
  })
  description = "AWS account settings"
}

variable "account_variable_set_clear_text_env_variables" {
  type        = map(string)
  default     = {}
  description = ""
}

variable "account_variable_set_clear_text_hcl_variables" {
  type        = map(string)
  default     = {}
  description = ""
}

variable "account_variable_set_clear_text_terraform_variables" {
  type        = map(string)
  default     = {}
  description = ""
}

variable "account_variable_set_sensitive_env_variables" {
  type        = map(string)
  default     = {}
  description = ""
}

variable "account_variable_set_sensitive_hcl_variables" {
  type        = map(object({ sensitive = string }))
  default     = {}
  description = ""
}

variable "account_variable_set_sensitive_terraform_variables" {
  type        = map(string)
  default     = {}
  description = ""
}

variable "additional_tfe_workspaces" {
  type = map(object({
    add_permissions_boundary       = optional(bool, false)
    agent_pool_id                  = optional(string)
    agent_role_arns                = optional(list(string))
    allow_destroy_plan             = optional(bool)
    assessments_enabled            = optional(bool)
    auth_method                    = optional(string)
    auto_apply                     = optional(bool, false)
    auto_apply_run_trigger         = optional(bool, false)
    branch                         = optional(string)
    clear_text_env_variables       = optional(map(string), {})
    clear_text_hcl_variables       = optional(map(string), {})
    clear_text_terraform_variables = optional(map(string), {})
    connect_vcs_repo               = optional(bool, true)
    default_region                 = optional(string)
    description                    = optional(string)
    execution_mode                 = optional(string)
    file_triggers_enabled          = optional(bool, true)
    global_remote_state            = optional(bool, false)
    name                           = optional(string)
    policy                         = optional(string)
    policy_arns                    = optional(list(string), ["arn:aws:iam::aws:policy/AdministratorAccess"])
    project_id                     = optional(string)
    queue_all_runs                 = optional(bool)
    remote_state_consumer_ids      = optional(set(string))
    repository_identifier          = optional(string)
    role_name                      = optional(string)
    sensitive_env_variables        = optional(map(string), {})
    sensitive_hcl_variables        = optional(map(object({ sensitive = string })), {})
    sensitive_terraform_variables  = optional(map(string), {})
    ssh_key_id                     = optional(string)
    terraform_version              = optional(string)
    trigger_patterns               = optional(list(string))
    trigger_prefixes               = optional(list(string))
    username                       = optional(string)
    vcs_oauth_token_id             = optional(string)
    variable_set_ids               = optional(map(string), {})
    working_directory              = optional(string)
    workspace_tags                 = optional(list(string))
    notification_configuration = optional(list(object({
      destination_type = string
      enabled          = optional(bool, true)
      url              = string
      triggers = optional(list(string), [
        "run:created",
        "run:planning",
        "run:needs_attention",
        "run:applying",
        "run:completed",
        "run:errored",
      ])
    })), [])

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

variable "path" {
  type        = string
  default     = "/"
  description = "Optional path for all IAM users, user groups, roles, and customer managed policies created by this module"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to assign to all resources"
}

variable "permissions_boundaries" {
  type = object({
    workspace_boundary      = optional(string)
    workspace_boundary_name = optional(string)
    workload_boundary       = optional(string)
    workload_boundary_name  = optional(string)
  })
  default = {}
}

variable "tfe_workspace" {
  type = object({
    add_permissions_boundary       = optional(bool, false)
    agent_pool_id                  = optional(string)
    agent_role_arns                = optional(list(string))
    allow_destroy_plan             = optional(bool, true)
    assessments_enabled            = optional(bool, true)
    auth_method                    = optional(string, "iam_role_oidc")
    auto_apply                     = optional(bool, false)
    auto_apply_run_trigger         = optional(bool, false)
    branch                         = optional(string, "main")
    clear_text_env_variables       = optional(map(string), {})
    clear_text_hcl_variables       = optional(map(string), {})
    clear_text_terraform_variables = optional(map(string), {})
    connect_vcs_repo               = optional(bool, true)
    default_region                 = string
    description                    = optional(string)
    execution_mode                 = optional(string, "remote")
    file_triggers_enabled          = optional(bool, true)
    global_remote_state            = optional(bool, false)
    name                           = optional(string)
    organization                   = string
    policy                         = optional(string)
    policy_arns                    = optional(list(string), ["arn:aws:iam::aws:policy/AdministratorAccess"])
    project_id                     = optional(string)
    queue_all_runs                 = optional(bool)
    remote_state_consumer_ids      = optional(set(string))
    repository_identifier          = optional(string)
    role_name                      = optional(string, "TFEPipeline")
    sensitive_env_variables        = optional(map(string), {})
    sensitive_hcl_variables        = optional(map(object({ sensitive = string })), {})
    sensitive_terraform_variables  = optional(map(string), {})
    ssh_key_id                     = optional(string)
    terraform_version              = optional(string)
    trigger_patterns               = optional(list(string))
    trigger_prefixes               = optional(list(string), ["modules"])
    username                       = optional(string, "TFEPipeline")
    vcs_oauth_token_id             = string
    variable_set_ids               = optional(map(string), {})
    working_directory              = optional(string, null)
    workspace_tags                 = optional(list(string), null)

    notification_configuration = optional(list(object({
      destination_type = string
      enabled          = optional(bool, true)
      url              = string
      triggers = optional(list(string), [
        "run:created",
        "run:planning",
        "run:needs_attention",
        "run:applying",
        "run:completed",
        "run:errored",
      ])
    })), [])

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
