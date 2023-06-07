# terraform-aws-mcaf-avm

Terraform module providing an AWS Account Vending Machine (AVM). This module provisions an AWS account using the "AWS Control Tower Account Factory" product in Service Catalog with one or more Terraform Cloud/Enterprise (TFE) workspaces backed by a VCS project.

## Workspace authentication

Using the default values, this module will create an IAM user per workspace in the provisioned AWS account. If using self-hosted Terraform Cloud agents then it is recommended to rather use an IAM role to authenticate with the AWS account. This is in line with authentication best practices to use IAM roles over IAM users with long-lived tokens.

To use IAM roles for authentication:

- Set `var.tfe_workspace.agent_pool_id` or (`agent_pool_id` if specifying additional workspaces) to the Terraform Cloud agent pool ID
- Set `var.tfe_workspace.auth_method` or (`auth_method` if specifying additional workspaces) to `iam_role`
- Set `var.tfe_workspace.agent_role_arns` or (`agent_role_arns` if specifying additional workspaces) to the IAM role assumed by the Terraform Cloud agents in the specified agent pool

This will create an IAM role in the provisioned AWS account with a randomly generated external ID which can only be assumed by the Terraform Cloud agent role. The created role and external ID value are stored in the new workspace as Terraform variables which can be used to configure your AWS provider. Using the default workspace the created role will be called `TPEPipelineRole`, role names for additional workspaces will be calculated for you based on the workspace name but you can always set your own via the `role_name` variable (similarly you can set your own role name in the default workspace via `var.tfe_workspace.role_name`); but please be aware that each IAM role must have a unique name.

To use the created IAM role, use the following when configuring your AWS provider:

```hcl
provider "aws" {
  assume_role {
    role_arn     = var.aws_assume_role
    external_id  = var.aws_assume_role_external_id
    session_name = "tfe-agent"
  }
}
```

## Workspace team access

Team access can be configured per workspace using the `team_access` variable.

As the state is considered sensitive, we recommend the following custom role permissions which is similar to the pre-existing "write" permission but blocks read access to the state (viewing outputs is still allowed):

```hcl
team_access = {
  "MyTeamName" = {
    permissions = {
      run_tasks         = false
      runs              = "apply"
      sentinel_mocks    = "read"
      state_versions    = "read-outputs"
      variables         = "write"
      workspace_locking = true
    }
  }
}
```

More complete usage information can be found in the underlying [terraform-aws-mcaf-workspace module README](https://github.com/schubergphilis/terraform-aws-mcaf-workspace#team-access).

Note: the team should already exist, this module will not create it for you.

## AWS SSO Configuration

In the `account` variable, the SSO attributes (`sso_email`, `sso_firstname` and `sso_lastname`) will be used by AWS Service Catalog to provide initial access to the newly created account.

You should use the details from the AWS Control Tower Admin user.

## How to use

### Basic configuration

```hcl
module "aws_account" {
  source = "github.com/schubergphilis/terraform-aws-mcaf-avm?ref=VERSION"

  name = "my-aws-account"
  tags = { Terraform = true }

  account = {
    email               = "my-aws-account@email.com"
    environment         = "prod"
    organizational_unit = "Production"
    sso_email           = "control-tower-admin@company.com"
  }

  tfe_workspace = {
    default_region        = "eu-west-1"
    repository_identifier = "myorg/myworkspacerepo"
    organization          = "myorg"
    vcs_oauth_token_id    = var.oauth_token_id
  }
}
```

### Additional workspaces

```hcl
module "aws_account" {
  source = "github.com/schubergphilis/terraform-aws-mcaf-avm?ref=VERSION"

  name = "my-aws-account"
  tags = { Terraform = true }

  account = {
    email               = "my-aws-account@email.com"
    environment         = "prod"
    organizational_unit = "Production"
    sso_email           = "control-tower-admin@company.com"
  }

  tfe_workspace = {
    default_region        = "eu-west-1"
    repository_identifier = "schubergphilis/terraform-aws-mcaf-avm"
    organization          = "schubergphilis"
    vcs_oauth_token_id    = var.oauth_token_id
  }

  additional_tfe_workspaces = {
    baseline-my-aws-account = {
      auto_apply            = true
      repository_identifier = "schubergphilis/terraform-aws-mcaf-account-baseline"
    }
  }
}
```

### Only deploy additional workspaces

```hcl
module "aws_account" {
  source = "github.com/schubergphilis/terraform-aws-mcaf-avm?ref=VERSION"

  create_default_workspace = false
  name                     = "my-aws-account"
  tags                     = { Terraform = true }

  account = {
    email               = "my-aws-account@email.com"
    environment         = "prod"
    organizational_unit = "Production"
    sso_email           = "control-tower-admin@company.com"
  }

  tfe_workspace = {
    default_region        = "eu-west-1"
    repository_identifier = "schubergphilis/terraform-aws-mcaf-avm"
    organization          = "schubergphilis"
    vcs_oauth_token_id    = var.oauth_token_id
  }

  additional_tfe_workspaces = {
    my-aws-account-subsystem1 = {
      working_directory = "terraform/subsystem1"
    }
    my-aws-account-subsystem2 = {
      working_directory = "terraform/subsystem2"
    }
  }
}
```

## IAM Permissions Boundaries

The module supports setting a Permission Boundary on the workspace `iam_user` or `iam_role` by passing down `permissions_boundaries.workspace_boundary`, which needs to be referencing the path where the permissions boundary is stored in git and the name: `permissions_boundaries.workspace_boundary_name`. By setting `var.tfe_workspace.add_permissions_boundary` or `var.additional_tfe_workspaces.add_permissions_boundary` to `true`, the permissions boundary will be attached to that specific workspace user/role.

In case you want to reference a permission boundary that needs to be attached to every IAM role/user that will be created by the workspace role/user then you can create this permission boundary by specifying `permissions_boundaries.workload_boundary` which needs to be referencing the path where the permissions boundary is stored in git and the name: `permissions_boundaries.workload_boundary_name`.

```hcl
module "aws_account" {
  source = "github.com/schubergphilis/terraform-aws-mcaf-avm?ref=VERSION"
  ...
  permissions_boundaries = {
    workspace_boundary      = "${path.module}/workspace_boundary.json"
    workspace_boundary_name = "workspace_boundary"
    workload_boundary       = "${path.module}/workload_boundary.json"
    workload_boundary_name  = "workload_boundary"
  }
  ...
}
```

Note: the `workspace_boundary` and `workload_boundary` can be templated files, `account_id` will be replaced by AVM by the account ID of the AWS account created.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.9.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | >= 4.0.0 |
| <a name="requirement_mcaf"></a> [mcaf](#requirement\_mcaf) | >= 0.4.2 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | >= 0.25.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.account"></a> [aws.account](#provider\_aws.account) | >= 4.9.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_account"></a> [account](#module\_account) | github.com/schubergphilis/terraform-aws-mcaf-account | v0.5.1 |
| <a name="module_additional_tfe_workspaces"></a> [additional\_tfe\_workspaces](#module\_additional\_tfe\_workspaces) | github.com/schubergphilis/terraform-aws-mcaf-workspace | v0.14.1 |
| <a name="module_tfe_workspace"></a> [tfe\_workspace](#module\_tfe\_workspace) | github.com/schubergphilis/terraform-aws-mcaf-workspace | v0.14.1 |

## Resources

| Name | Type |
|------|------|
| [aws_account_alternate_contact.billing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_alternate_contact) | resource |
| [aws_account_alternate_contact.operations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_alternate_contact) | resource |
| [aws_account_alternate_contact.security](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_alternate_contact) | resource |
| [aws_iam_account_alias.alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_account_alias) | resource |
| [aws_iam_policy.workload_boundary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.workspace_boundary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account"></a> [account](#input\_account) | AWS account settings | <pre>object({<br>    alias_prefix = optional(string, null)<br>    contact_billing = optional(object({<br>      email_address = string<br>      name          = string<br>      phone_number  = string<br>      title         = string<br>    }), null)<br>    contact_operations = optional(object({<br>      email_address = string<br>      name          = string<br>      phone_number  = string<br>      title         = string<br>    }), null)<br>    contact_security = optional(object({<br>      email_address = string<br>      name          = string<br>      phone_number  = string<br>      title         = string<br>    }), null)<br>    email                    = string<br>    environment              = optional(string, null)<br>    organizational_unit      = string<br>    provisioned_product_name = optional(string, null)<br>    sso_email                = string<br>    sso_firstname            = optional(string, "AWS Control Tower")<br>    sso_lastname             = optional(string, "Admin")<br>  })</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the account and default TFE workspace | `string` | n/a | yes |
| <a name="input_tfe_workspace"></a> [tfe\_workspace](#input\_tfe\_workspace) | TFE workspace settings | <pre>object({<br>    add_permissions_boundary       = optional(bool, false)<br>    agent_pool_id                  = optional(string, null)<br>    agent_role_arns                = optional(list(string), null)<br>    auth_method                    = optional(string, "iam_user")<br>    auto_apply                     = optional(bool, false)<br>    branch                         = optional(string, "main")<br>    clear_text_env_variables       = optional(map(string), {})<br>    clear_text_hcl_variables       = optional(map(string), {})<br>    clear_text_terraform_variables = optional(map(string), {})<br>    connect_vcs_repo               = optional(bool, true)<br>    default_region                 = string<br>    execution_mode                 = optional(string, "remote")<br>    file_triggers_enabled          = optional(bool, true)<br>    global_remote_state            = optional(bool, false)<br>    name                           = optional(string, null)<br>    policy                         = optional(string, null)<br>    policy_arns                    = optional(list(string), ["arn:aws:iam::aws:policy/AdministratorAccess"])<br>    project_id                     = optional(string, null)<br>    remote_state_consumer_ids      = optional(set(string))<br>    repository_identifier          = optional(string, null)<br>    role_name                      = optional(string, "TFEPipeline")<br>    sensitive_env_variables        = optional(map(string), {})<br>    sensitive_hcl_variables        = optional(map(object({ sensitive = string })), {})<br>    sensitive_terraform_variables  = optional(map(string), {})<br>    slack_notification_triggers    = optional(list(string), ["run:created", "run:planning", "run:needs_attention", "run:applying", "run:completed", "run:errored"])<br>    slack_notification_url         = optional(string, null)<br>    ssh_key_id                     = optional(string, null)<br>    organization                   = string<br>    terraform_version              = optional(string, null)<br>    trigger_prefixes               = optional(list(string), ["modules"])<br>    username                       = optional(string, "TFEPipeline")<br>    vcs_oauth_token_id             = string<br>    working_directory              = optional(string, null)<br><br>    team_access = optional(map(object({<br>      access = optional(string, null),<br>      permissions = optional(object({<br>        run_tasks         = bool<br>        runs              = string<br>        sentinel_mocks    = string<br>        state_versions    = string<br>        variables         = string<br>        workspace_locking = bool<br>      }), null)<br>    })), {})<br>  })</pre> | n/a | yes |
| <a name="input_additional_tfe_workspaces"></a> [additional\_tfe\_workspaces](#input\_additional\_tfe\_workspaces) | Additional TFE workspaces | <pre>map(object({<br>    add_permissions_boundary       = optional(bool, false)<br>    agent_pool_id                  = optional(string, null)<br>    agent_role_arns                = optional(list(string), null)<br>    auth_method                    = optional(string, null)<br>    auto_apply                     = optional(bool, false)<br>    branch                         = optional(string, null)<br>    clear_text_env_variables       = optional(map(string), {})<br>    clear_text_hcl_variables       = optional(map(string), {})<br>    clear_text_terraform_variables = optional(map(string), {})<br>    connect_vcs_repo               = optional(bool, true)<br>    default_region                 = optional(string, null)<br>    execution_mode                 = optional(string, null)<br>    file_triggers_enabled          = optional(bool, true)<br>    global_remote_state            = optional(bool, false)<br>    name                           = optional(string, null)<br>    policy                         = optional(string, null)<br>    policy_arns                    = optional(list(string), ["arn:aws:iam::aws:policy/AdministratorAccess"])<br>    project_id                     = optional(string, null)<br>    remote_state_consumer_ids      = optional(set(string))<br>    repository_identifier          = optional(string, null)<br>    role_name                      = optional(string, null)<br>    sensitive_env_variables        = optional(map(string), {})<br>    sensitive_hcl_variables        = optional(map(object({ sensitive = string })), {})<br>    sensitive_terraform_variables  = optional(map(string), {})<br>    slack_notification_triggers    = optional(list(string), null)<br>    slack_notification_url         = optional(string, null)<br>    ssh_key_id                     = optional(string, null)<br>    terraform_version              = optional(string, null)<br>    trigger_prefixes               = optional(list(string), null)<br>    username                       = optional(string, null)<br>    vcs_oauth_token_id             = optional(string, null)<br>    working_directory              = optional(string, null)<br><br>    team_access = optional(map(object({<br>      access = optional(string, null),<br>      permissions = optional(object({<br>        run_tasks         = bool<br>        runs              = string<br>        sentinel_mocks    = string<br>        state_versions    = string<br>        variables         = string<br>        workspace_locking = bool<br>      }), null)<br>    })), {})<br>  }))</pre> | `{}` | no |
| <a name="input_create_default_workspace"></a> [create\_default\_workspace](#input\_create\_default\_workspace) | Set to false to skip creating default workspace | `bool` | `true` | no |
| <a name="input_path"></a> [path](#input\_path) | Optional path for all IAM users, user groups, roles, and customer managed policies created by this module | `string` | `"/"` | no |
| <a name="input_permissions_boundaries"></a> [permissions\_boundaries](#input\_permissions\_boundaries) | n/a | <pre>object({<br>    workspace_boundary      = optional(string, null)<br>    workspace_boundary_name = optional(string, null)<br>    workload_boundary       = optional(string, null)<br>    workload_boundary_name  = optional(string, null)<br>  })</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_additional_tfe_workspace"></a> [additional\_tfe\_workspace](#output\_additional\_tfe\_workspace) | Map of additional TFE workspaces containing name and workspace ID |
| <a name="output_id"></a> [id](#output\_id) | The AWS account ID |
| <a name="output_tfe_workspace_id"></a> [tfe\_workspace\_id](#output\_tfe\_workspace\_id) | The TFE workspace ID |
| <a name="output_workload_permissions_boundary_arn"></a> [workload\_permissions\_boundary\_arn](#output\_workload\_permissions\_boundary\_arn) | The ARN of the workload permissions boundary |
<!-- END_TF_DOCS -->
