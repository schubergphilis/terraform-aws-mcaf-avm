# terraform-aws-mcaf-avm

Terraform module providing an AWS Account Vending Machine (AVM). This module sets up an AWS account with one or more Terraform Cloud/Enterprise (TFE) workspace(s) backed by a VCS project.

## AWS SSO Configuration

In the `account_settings` variable, the SSO attributes (`sso_email`, `sso_firstname` and `sso_lastname`) will be used by AWS Service Catalog to provide initial access to the newly created account.

You should use the details from the AWS Control Tower Admin user.

## How to use

### Basic configuration

```hcl
module "aws_account" {
  source = "github.com/schubergphilis/terraform-aws-mcaf-avm?ref=VERSION"

  name = "my-aws-account"

  account_settings = {
    email                = "my-aws-account@email.com"
    environment          = "prod"
    organizational_unit  = "Production"
    sso_email            = "control-tower-admin@schubergphilis.com"
  }

  tfe_workspace_settings = {
    oauth_token_id            = var.oauth_token_id
    repository_identifier     = "schubergphilis/terraform-aws-mcaf-avm"
    terraform_organization    = "schubergphilis"
  }
}
```

### Additional workspaces

```hcl
module "aws_account" {
  source = "github.com/schubergphilis/terraform-aws-mcaf-avm?ref=VERSION"

  name = "my-aws-account"

  account_settings = {
    email                = "my-aws-account@email.com"
    environment          = "prod"
    organizational_unit  = "Production"
    sso_email            = "control-tower-admin@schubergphilis.com"
  }

  tfe_workspace_settings = {
    oauth_token_id            = var.oauth_token_id
    repository_identifier     = "schubergphilis/terraform-aws-mcaf-avm"
    terraform_organization    = "schubergphilis"
  }

  additional_tfe_workspaces = [
    {
      auto_apply                     = true
      name                           = "my-aws-account-baseline"
      oauth_token_id                 = var.oauth_token_id
      repository_identifier          = "schubergphilis/terraform-aws-mcaf-avm"
      terraform_organization         = "schubergphilis"
      terraform_version              = "1.0.6"
      working_directory              = "terraform/additional"
    }
  ]
}
```

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3.0 |
| mcaf | >= 0.4.2 |
| tfe | >= 0.25.0 |

## Providers

| Name | Version |
|------|---------|
| aws.account | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| account\_settings | Account settings | <pre>object({<br>    alias_prefix        = string<br>    email               = string<br>    environment         = string<br>    organizational_unit = string<br>    sso_email           = string<br>    sso_firstname       = optional(string, "AWS Control Tower")<br>    sso_lastname        = optional(string, "Admin")<br>  })</pre> | n/a | yes |
| name | Name of the account | `string` | n/a | yes |
| region | The default region of the account | `string` | n/a | yes |
| tags | A mapping of tags to assign to resource | `map(string)` | n/a | yes |
| additional\_tfe\_workspaces | Additional TFE Workspaces | <pre>map(object({<br>    agent_pool_id                  = optional(string, null)<br>    auto_apply                     = optional(bool, false)<br>    branch                         = optional(string, "main")<br>    clear_text_env_variables       = optional(map(string), {})<br>    clear_text_hcl_variables       = optional(map(string), {})<br>    clear_text_terraform_variables = optional(map(string), {})<br>    execution_mode                 = optional(string, "remote")<br>    file_triggers_enabled          = optional(bool, true)<br>    global_remote_state            = optional(bool, false)<br>    oauth_token_id                 = string<br>    policy                         = optional(string, null)<br>    policy_arns                    = optional(list(string), ["arn:aws:iam::aws:policy/AdministratorAccess"])<br>    remote_state_consumer_ids      = optional(set(string))<br>    repository_identifier          = string<br>    sensitive_env_variables        = optional(map(string), {})<br>    sensitive_hcl_variables        = optional(map(object({ sensitive = string })), {})<br>    sensitive_terraform_variables  = optional(map(string), {})<br>    slack_notification_triggers    = optional(list(string), ["run:created", "run:planning", "run:needs_attention", "run:applying", "run:completed", "run:errored"])<br>    slack_notification_url         = optional(string, null)<br>    ssh_key_id                     = optional(string, null)<br>    team_access                    = optional(map(object({ access = string, team_id = string, })), {})<br>    terraform_organization         = string<br>    terraform_version              = optional(string, null)<br>    trigger_prefixes               = optional(list(string), ["modules"])<br>    username                       = optional(string, null)<br>    working_directory              = optional(string, "terraform")<br>  }))</pre> | `{}` | no |
| tfe\_workspace\_agent\_pool\_id | Agent pool ID | `string` | `null` | no |
| tfe\_workspace\_auto\_apply | Whether to automatically apply changes when a Terraform plan is successful | `bool` | `false` | no |
| tfe\_workspace\_branch | The Git branch to trigger the TFE workspace for | `string` | `"main"` | no |
| tfe\_workspace\_clear\_text\_env\_variables | An optional map with clear text environment variables | `map(string)` | `{}` | no |
| tfe\_workspace\_clear\_text\_hcl\_variables | An optional map with clear text HCL Terraform variables | `map(string)` | `{}` | no |
| tfe\_workspace\_clear\_text\_terraform\_variables | An optional map with clear text Terraform variables | `map(string)` | `{}` | no |
| tfe\_workspace\_execution\_mode | Which TFE workspace execution mode to use | `string` | `"remote"` | no |
| tfe\_workspace\_file\_triggers\_enabled | Whether to filter runs based on the changed files in a VCS push | `bool` | `true` | no |
| tfe\_workspace\_name | Custom workspace name (overrides var.name) | `string` | `null` | no |
| tfe\_workspace\_policy | The policy to attach to the pipeline user | `string` | `null` | no |
| tfe\_workspace\_policy\_arns | A set of policy ARNs to attach to the pipeline user | `list(string)` | <pre>[<br>  "arn:aws:iam::aws:policy/AdministratorAccess"<br>]</pre> | no |
| tfe\_workspace\_sensitive\_env\_variables | An optional map with sensitive environment variables | `map(string)` | `{}` | no |
| tfe\_workspace\_sensitive\_hcl\_variables | An optional map with sensitive HCL Terraform variables | <pre>map(object({<br>    sensitive = string<br>  }))</pre> | `{}` | no |
| tfe\_workspace\_sensitive\_terraform\_variables | An optional map with sensitive Terraform variables | `map(string)` | `{}` | no |
| tfe\_workspace\_settings | TFE Workspaces settings | <pre>object({<br>    global_remote_state       = optional(bool, false)<br>    oauth_token_id            = string<br>    remote_state_consumer_ids = optional(set(string))<br>    repository_identifier     = string<br>    terraform_organization    = string<br>    terraform_version         = optional(string, null)<br>    working_directory         = optional(string, "terraform")<br>  })</pre> | `null` | no |
| tfe\_workspace\_slack\_notification\_triggers | The triggers to send to Slack | `list(string)` | <pre>[<br>  "run:created",<br>  "run:planning",<br>  "run:needs_attention",<br>  "run:applying",<br>  "run:completed",<br>  "run:errored"<br>]</pre> | no |
| tfe\_workspace\_slack\_notification\_url | The Slack Webhook URL to send notification to | `string` | `null` | no |
| tfe\_workspace\_ssh\_key\_id | The SSH key ID to assign to the workspace | `string` | `null` | no |
| tfe\_workspace\_team\_access | An optional map with team IDs and workspace access permissions to assign | <pre>map(object({<br>    access  = string,<br>    team_id = string,<br>  }))</pre> | `{}` | no |
| tfe\_workspace\_trigger\_prefixes | List of repository-root-relative paths which should be tracked for changes | `list(string)` | <pre>[<br>  "modules"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| additional\_tfe\_workspace | Map of additional TFE workspaces containing name and workspace ID |
| id | The AWS account ID |
| tfe\_workspace\_id | The TFE workspace ID |

<!--- END_TF_DOCS --->
