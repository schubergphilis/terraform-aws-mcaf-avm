variable "account" {
  type = object({
    alias_prefix = optional(string, null)
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
    add_permissions_boundary       = optional(bool, false)
    agent_pool_id                  = optional(string, null)
    agent_role_arns                = optional(list(string), null)
    auth_method                    = optional(string, null)
    auto_apply                     = optional(bool, false)
    branch                         = optional(string, null)
    clear_text_env_variables       = optional(map(string), {})
    clear_text_hcl_variables       = optional(map(string), {})
    clear_text_terraform_variables = optional(map(string), {})
    connect_vcs_repo               = optional(bool, true)
    default_region                 = optional(string, null)
    execution_mode                 = optional(string, null)
    file_triggers_enabled          = optional(bool, true)
    global_remote_state            = optional(bool, false)
    name                           = optional(string, null)
    policy                         = optional(string, null)
    policy_arns                    = optional(list(string), ["arn:aws:iam::aws:policy/AdministratorAccess"])
    project_id                     = optional(string, null)
    queue_all_runs                 = optional(bool, null)
    remote_state_consumer_ids      = optional(set(string))
    repository_identifier          = optional(string, null)
    role_name                      = optional(string, null)
    sensitive_env_variables        = optional(map(string), {})
    sensitive_hcl_variables        = optional(map(object({ sensitive = string })), {})
    sensitive_terraform_variables  = optional(map(string), {})
    ssh_key_id                     = optional(string, null)
    terraform_version              = optional(string, null)
    trigger_prefixes               = optional(list(string), null)
    username                       = optional(string, null)
    vcs_oauth_token_id             = optional(string, null)
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
    workspace_boundary      = optional(string, null)
    workspace_boundary_name = optional(string, null)
    workload_boundary       = optional(string, null)
    workload_boundary_name  = optional(string, null)
  })
  default = {}
}

variable "tfe_workspace" {
  type = object({
    add_permissions_boundary       = optional(bool, false)
    agent_pool_id                  = optional(string, null)
    agent_role_arns                = optional(list(string), null)
    auth_method                    = optional(string, "iam_user")
    auto_apply                     = optional(bool, false)
    branch                         = optional(string, "main")
    clear_text_env_variables       = optional(map(string), {})
    clear_text_hcl_variables       = optional(map(string), {})
    clear_text_terraform_variables = optional(map(string), {})
    connect_vcs_repo               = optional(bool, true)
    default_region                 = string
    execution_mode                 = optional(string, "remote")
    file_triggers_enabled          = optional(bool, true)
    global_remote_state            = optional(bool, false)
    name                           = optional(string, null)
    policy                         = optional(string, null)
    policy_arns                    = optional(list(string), ["arn:aws:iam::aws:policy/AdministratorAccess"])
    project_id                     = optional(string, null)
    queue_all_runs                 = optional(bool, null)
    remote_state_consumer_ids      = optional(set(string))
    repository_identifier          = optional(string, null)
    role_name                      = optional(string, "TFEPipeline")
    sensitive_env_variables        = optional(map(string), {})
    sensitive_hcl_variables        = optional(map(object({ sensitive = string })), {})
    sensitive_terraform_variables  = optional(map(string), {})
    ssh_key_id                     = optional(string, null)
    organization                   = string
    terraform_version              = optional(string, null)
    trigger_prefixes               = optional(list(string), ["modules"])
    username                       = optional(string, "TFEPipeline")
    vcs_oauth_token_id             = string
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
