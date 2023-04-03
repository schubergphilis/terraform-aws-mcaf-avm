# terraform-aws-mcaf-avm

Terraform module providing an AWS Account Vending Machine (AVM). This module provisions an AWS account using the "AWS Control Tower Account Factory" product in Service Catalog with one or more Terraform Cloud/Enterprise workspaces (each backed by a VCS project).

## Workspace authentication

Using the default values, this module will create an IAM user per workspace in the provisioned AWS account. If using self-hosted Terraform Cloud agents then it is recommended to rather use an IAM role to authenticate with the AWS account. This is in line with authentication best practices to use IAM roles over IAM users with long-lived tokens.

To use IAM roles for authentication:

- Set `var.tfe_workspace.agent_pool_id` or (`agent_pool_id` if specifying additional workspaces) to the Terraform Cloud agent pool ID
- Set `var.tfe_workspace.auth_method` or (`auth_method` if specifying additional workspaces) to `iam_role`
- Set `var.tfe_workspace.agent_role_arns` or (`agent_role_arns` if specifying additional workspaces) to the IAM role assumed by the Terraform Cloud agents in the specified agent pool

This will create an IAM role in the provisioned AWS account with a randomly generated external ID which can only be assumed by the Terraform Cloud agent role. The created role and external ID value are stored in the new workspace as Terraform variables which can be used to configure your AWS provider. When using the default workspace the created role will be named `TPEPipelineRole`. Role names for additional workspaces will be calculated for you based on the workspace name but you can always set your own via the `role_name` attribute (similarly you can set your own role name in the default workspace via `var.tfe_workspace.role_name`).

> **Warning**
> Please be aware that each IAM role must have a unique name in the account.

To use the created IAM role, configure the AWS provider as shown below:

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

Team access can be configured per workspace using `var.team_access`.

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

> **Note**
> The team should already exist in Terraform Cloud/Enterprise, this module will not create it for you.

## AWS SSO Configuration

In `var.account` the SSO attributes (`sso_email`, `sso_firstname` and `sso_lastname`) will be used by AWS Service Catalog to provide initial access to the newly created account.

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
    repository_identifier = "schubergphilis/terraform-aws-mcaf-avm"
    organization          = "schubergphilis"
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

## Permissions boundaries for IAM entities

A permissions boundary is an advanced feature for using a managed policy to set the maximum permissions that an identity-based policy can grant to an IAM entity. An entity's permissions boundary allows it to perform only the actions that are allowed by both its identity-based policies and its permissions boundaries, such as preventing Terraform from creating a user or role with elevated privileges that an end-user could use to gain extra access.

[See the AWS documentation](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_boundaries.html) to learn more.

This module supports attaching a permissions boundary on the role or user used by the workspace (`workspace_` prefix), as well as attaching a permission boundary to any created IAM role or user (`workload_` prefix).

> **Note**
> `workspace_boundary` and `workload_boundary` will be parsed by `templatefile`, so you can pass a template containing `account_id` to use the AWS account ID in your boundary policy.

### Workspace permissions boundary

To create an attach a permissions boundary to the role or user used by the default workspace provider, specify the path to the policy and the desired policy name:

```hcl
  permissions_boundaries = {
    workspace_boundary      = "${path.module}/policies/workspace_boundary.json"
    workspace_boundary_name = "workspace_boundary"
  }
```

### IAM resource permissions boundaries

Similar to how a workspace permissions boundary is set, you can also attach a permissions boundary to any IAM role or user that is created by the workspace:

```hcl
  permissions_boundaries = {
    workload_boundary       = "${path.module}/policies/workload_boundary.json"
    workload_boundary_name  = "workload_boundary"
  }
```

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3.0 |
| aws | >= 4.9.0 |
| github | >= 4.0.0 |
| mcaf | >= 0.4.2 |
| tfe | >= 0.25.0 |

## Providers

| Name | Version |
|------|---------|
| aws.account | >= 4.9.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| account | AWS account settings | <pre>object({<br>    alias_prefix = optional(string, null)<br>    contact_billing = optional(object({<br>      email_address = string<br>      name          = string<br>      phone_number  = string<br>      title         = string<br>    }), null)<br>    contact_operations = optional(object({<br>      email_address = string<br>      name          = string<br>      phone_number  = string<br>      title         = string<br>    }), null)<br>    contact_security = optional(object({<br>      email_address = string<br>      name          = string<br>      phone_number  = string<br>      title         = string<br>    }), null)<br>    email                    = string<br>    environment              = optional(string, null)<br>    organizational_unit      = string<br>    provisioned_product_name = optional(string, null)<br>    sso_email                = string<br>    sso_firstname            = optional(string, "AWS Control Tower")<br>    sso_lastname             = optional(string, "Admin")<br>  })</pre> | n/a | yes |
| name | Name of the account and default TFE workspace | `string` | n/a | yes |
| tags | A map of tags to assign to all resources | `map(string)` | n/a | yes |
| tfe\_workspace | TFE workspace settings | <pre>object({<br>    agent_pool_id                  = optional(string, null)<br>    agent_role_arns                = optional(list(string), null)<br>    auth_method                    = optional(string, "iam_user")<br>    auto_apply                     = optional(bool, false)<br>    branch                         = optional(string, "main")<br>    clear_text_env_variables       = optional(map(string), {})<br>    clear_text_hcl_variables       = optional(map(string), {})<br>    clear_text_terraform_variables = optional(map(string), {})<br>    default_region                 = string<br>    execution_mode                 = optional(string, "remote")<br>    file_triggers_enabled          = optional(bool, true)<br>    global_remote_state            = optional(bool, false)<br>    name                           = optional(string, null)<br>    policy                         = optional(string, null)<br>    policy_arns                    = optional(list(string), ["arn:aws:iam::aws:policy/AdministratorAccess"])<br>    project_id                     = optional(string, null)<br>    remote_state_consumer_ids      = optional(set(string))<br>    repository_identifier          = string<br>    role_name                      = optional(string, "TFEPipeline")<br>    sensitive_env_variables        = optional(map(string), {})<br>    sensitive_hcl_variables        = optional(map(object({ sensitive = string })), {})<br>    sensitive_terraform_variables  = optional(map(string), {})<br>    slack_notification_triggers    = optional(list(string), ["run:created", "run:planning", "run:needs_attention", "run:applying", "run:completed", "run:errored"])<br>    slack_notification_url         = optional(string, null)<br>    ssh_key_id                     = optional(string, null)<br>    organization                   = string<br>    terraform_version              = optional(string, null)<br>    trigger_prefixes               = optional(list(string), ["modules"])<br>    username                       = optional(string, "TFEPipeline")<br>    vcs_oauth_token_id             = string<br>    working_directory              = optional(string, null)<br><br>    team_access = optional(map(object({<br>      access = optional(string, null),<br>      permissions = optional(object({<br>        run_tasks         = bool<br>        runs              = string<br>        sentinel_mocks    = string<br>        state_versions    = string<br>        variables         = string<br>        workspace_locking = bool<br>      }), null)<br>    })), {})<br>  })</pre> | n/a | yes |
| additional\_tfe\_workspaces | Additional TFE workspaces | <pre>map(object({<br>    agent_pool_id                  = optional(string, null)<br>    agent_role_arns                = optional(list(string), null)<br>    auth_method                    = optional(string, null)<br>    auto_apply                     = optional(bool, false)<br>    branch                         = optional(string, null)<br>    clear_text_env_variables       = optional(map(string), {})<br>    clear_text_hcl_variables       = optional(map(string), {})<br>    clear_text_terraform_variables = optional(map(string), {})<br>    default_region                 = optional(string, null)<br>    execution_mode                 = optional(string, null)<br>    file_triggers_enabled          = optional(bool, true)<br>    global_remote_state            = optional(bool, false)<br>    name                           = optional(string, null)<br>    policy                         = optional(string, null)<br>    policy_arns                    = optional(list(string), ["arn:aws:iam::aws:policy/AdministratorAccess"])<br>    project_id                     = optional(string, null)<br>    remote_state_consumer_ids      = optional(set(string))<br>    repository_identifier          = optional(string, null)<br>    role_name                      = optional(string, null)<br>    sensitive_env_variables        = optional(map(string), {})<br>    sensitive_hcl_variables        = optional(map(object({ sensitive = string })), {})<br>    sensitive_terraform_variables  = optional(map(string), {})<br>    slack_notification_triggers    = optional(list(string), null)<br>    slack_notification_url         = optional(string, null)<br>    ssh_key_id                     = optional(string, null)<br>    terraform_version              = optional(string, null)<br>    trigger_prefixes               = optional(list(string), null)<br>    username                       = optional(string, null)<br>    vcs_oauth_token_id             = optional(string, null)<br>    working_directory              = optional(string, null)<br><br>    team_access = optional(map(object({<br>      access = optional(string, null),<br>      permissions = optional(object({<br>        run_tasks         = bool<br>        runs              = string<br>        sentinel_mocks    = string<br>        state_versions    = string<br>        variables         = string<br>        workspace_locking = bool<br>      }), null)<br>    })), {})<br>  }))</pre> | `{}` | no |
| create\_default\_workspace | Set to false to skip creating default workspace | `bool` | `true` | no |
| path | Optional path for all IAM users, user groups, roles, and customer managed policies created by this module | `string` | `"/"` | no |
| permissions\_boundaries | n/a | <pre>object({<br>    workspace_boundary      = optional(string, null)<br>    workspace_boundary_name = optional(string, null)<br>    workload_boundary       = optional(string, null)<br>    workload_boundary_name  = optional(string, null)<br>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| additional\_tfe\_workspace | Map of additional TFE workspaces containing name and workspace ID |
| id | The AWS account ID |
| tfe\_workspace\_id | The TFE workspace ID |
| workload\_permissions\_boundary\_arn | The ARN of the workload permissions boundary |

<!--- END_TF_DOCS --->
