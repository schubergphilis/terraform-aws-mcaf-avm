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
  type = list(object({
    auto_apply                     = bool
    branch                         = string
    clear_text_env_variables       = map(string)
    clear_text_terraform_variables = map(string)
    create_repository              = bool
    github_organization            = string
    github_repository              = string
    kms_key_id                     = string
    name                           = string
    oauth_token_id                 = string
    policy_arns                    = list(string)
    sensitive_env_variables        = map(string)
    sensitive_terraform_variables  = map(string)
    ssh_key_id                     = string
    terraform_organization         = string
    terraform_version              = string
    trigger_prefixes               = list(string)
    working_directory              = string
  }))
  default     = []
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

variable "tfe_workspace_clear_text_terraform_variables" {
  type        = map(string)
  default     = {}
  description = "An optional map with clear text Terraform variables"
}

variable "tfe_workspace_create_repository" {
  type        = bool
  default     = false
  description = "Whether of not to create a new repository"
}

variable "tfe_workspace_kms_key_id" {
  type        = string
  default     = null
  description = "The KMS key ID used to encrypt the SSM parameters"
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
