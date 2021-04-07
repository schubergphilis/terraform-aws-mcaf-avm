variable "account_settings" {
  type = object({
    alias_prefix        = string
    email               = string
    environment         = string
    organizational_unit = string
    sso_email           = string
    sso_firstname       = string
    sso_lastname        = string
  })
  description = "Account settings"
}

variable "additional_tfe_workspaces" {
  type = map(object({
    agent_pool_id = string
    auto_apply    = bool
    branch        = string
    branch_protection = list(object({
      branches          = list(string)
      enforce_admins    = bool
      push_restrictions = list(string)

      required_reviews = object({
        dismiss_stale_reviews           = bool
        dismissal_restrictions          = list(string)
        required_approving_review_count = number
        require_code_owner_reviews      = bool
      })

      required_checks = object({
        strict   = bool
        contexts = list(string)
      })
    }))
    clear_text_env_variables       = map(string)
    clear_text_hcl_variables       = map(string)
    clear_text_terraform_variables = map(string)
    create_backend_config          = bool
    create_repository              = bool
    connect_vcs_repo               = bool
    delete_branch_on_merge         = bool
    file_triggers_enabled          = bool
    github_admins                  = list(string)
    github_organization            = string
    github_readers                 = list(string)
    github_repository              = string
    github_writers                 = list(string)
    kms_key_id                     = string
    oauth_token_id                 = string
    policy                         = string
    policy_arns                    = list(string)
    repository_description         = string
    repository_visibility          = string
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

variable "tfe_workspace_branch_protection" {
  type = list(object({
    branches          = list(string)
    enforce_admins    = bool
    push_restrictions = list(string)

    required_reviews = object({
      dismiss_stale_reviews           = bool
      dismissal_restrictions          = list(string)
      required_approving_review_count = number
      require_code_owner_reviews      = bool
    })

    required_checks = object({
      strict   = bool
      contexts = list(string)
    })
  }))
  default     = []
  description = "The Github branches to protect from forced pushes and deletion"
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

variable "tfe_workspace_create_backend_config" {
  type        = bool
  default     = true
  description = "Whether to create a backend.tf containing the remote backend config"
}

variable "tfe_workspace_create_repository" {
  type        = bool
  default     = false
  description = "Whether of not to create a new repository"
}

variable "tfe_workspace_connect_vcs_repo" {
  type        = bool
  default     = true
  description = "Whether or not to connect a VCS repo to the workspace"
}

variable "tfe_workspace_delete_branch_on_merge" {
  type        = bool
  default     = true
  description = "Whether or not to delete the branch after a pull request is merged"
}

variable "tfe_workspace_file_triggers_enabled" {
  type        = bool
  default     = true
  description = "Whether to filter runs based on the changed files in a VCS push"
}

variable "tfe_workspace_github_admins" {
  type        = list(string)
  default     = []
  description = "A list of Github teams that should have admins access"
}

variable "tfe_workspace_github_readers" {
  type        = list(string)
  default     = []
  description = "A list of Github teams that should have read access"
}

variable "tfe_workspace_github_writers" {
  type        = list(string)
  default     = []
  description = "A list of Github teams that should have write access"
}

variable "tfe_workspace_kms_key_id" {
  type        = string
  default     = null
  description = "The KMS key ID used to encrypt the SSM parameters"
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

variable "tfe_workspace_repository_description" {
  type        = string
  default     = null
  description = "A description for the Github repository"
}

variable "tfe_workspace_repository_visibility" {
  type        = string
  default     = "private"
  description = "Make the Github repository visibility"
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
    github_organization    = string
    github_repository      = string
    oauth_token_id         = string
    terraform_organization = string
    terraform_version      = string
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
