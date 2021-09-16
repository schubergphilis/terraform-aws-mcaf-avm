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
    create_email_address = true
    email                = "my-aws-account@email.com"
    environment          = "prod"
    organizational_unit  = "Production"
    sso_email            = "control-tower-admin@schubergphilis.com"
    sso_firstname        = "AWS Control Tower"
    sso_lastname         = "Admin"
  }

  tfe_workspace_settings = {
    oauth_token_id         = var.oauth_token_id
    repository_name        = "terraform-aws-mcaf-avm"
    repository_owner       = "schubergphilis"
    terraform_organization = "schubergphilis"
    terraform_version      = "1.0.6"
  }
}
```

### Additional workspaces

```hcl
module "aws_account" {
  source = "github.com/schubergphilis/terraform-aws-mcaf-avm?ref=VERSION"

  name = "my-aws-account"

  account_settings = {
    create_email_address = true
    email                = "my-aws-account@email.com"
    environment          = "prod"
    organizational_unit  = "Production"
    sso_email            = "control-tower-admin@schubergphilis.com"
    sso_firstname        = "AWS Control Tower"
    sso_lastname         = "Admin"
  }

  tfe_workspace_settings = {
    oauth_token_id         = var.oauth_token_id
    repository_name        = "terraform-aws-mcaf-avm"
    repository_owner       = "schubergphilis"
    terraform_organization = "schubergphilis"
    terraform_version      = "1.0.6"
  }

  additional_tfe_workspaces = [
    {
      agent_pool_id                  = null
      auto_apply                     = true
      branch                         = "master"
      clear_text_env_variables       = {}
      clear_text_hcl_variables       = {}
      clear_text_terraform_variables = {}
      create_repository              = false
      file_triggers_enabled          = true
      name                           = "my-aws-account-baseline"
      oauth_token_id                 = var.oauth_token_id
      policy                         = null
      policy_arns                    = ["arn:aws:iam::aws:policy/AdministratorAccess"]
      repository_name                = "terraform-aws-mcaf-avm"
      repository_owner               = "schubergphilis"
      sensitive_env_variables        = {}
      sensitive_hcl_variables        = {}
      sensitive_terraform_variables  = {}
      slack_notification_triggers    = []
      slack_notification_url         = null
      ssh_key_id                     = null
      terraform_organization         = "schubergphilis"
      terraform_version              = "1.0.6"
      trigger_prefixes               = null
      username                       = null
      working_directory              = "terraform"
    }
  ]
}
```

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| tfe | >= 0.25.0 |

## Providers

| Name | Version |
|------|---------|
| aws.account | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| account\_settings | Account settings | <pre>object({<br>    alias_prefix        = string<br>    email               = string<br>    environment         = string<br>    organizational_unit = string<br>    sso_email           = string<br>    sso_firstname       = string<br>    sso_lastname        = string<br>  })</pre> | n/a | yes |
| name | Name of the account | `string` | n/a | yes |
| tags | A mapping of tags to assign to resource | `map(string)` | n/a | yes |
| additional\_tfe\_workspaces | Additional TFE Workspaces | <pre>map(object({<br>    agent_pool_id                  = string<br>    auto_apply                     = bool<br>    branch                         = string<br>    clear_text_env_variables       = map(string)<br>    clear_text_hcl_variables       = map(string)<br>    clear_text_terraform_variables = map(string)<br>    execution_mode                 = string<br>    file_triggers_enabled          = bool<br>    oauth_token_id                 = string<br>    policy                         = string<br>    policy_arns                    = list(string)<br>    repository_name                = string<br>    repository_owner               = string<br>    sensitive_env_variables        = map(string)<br>    sensitive_hcl_variables        = map(object({ sensitive = string }))<br>    sensitive_terraform_variables  = map(string)<br>    slack_notification_triggers    = list(string)<br>    slack_notification_url         = string<br>    ssh_key_id                     = string<br>    terraform_organization         = string<br>    terraform_version              = string<br>    trigger_prefixes               = list(string)<br>    username                       = string<br>    working_directory              = string<br>  }))</pre> | `{}` | no |
| region | The default region of the account | `string` | `"eu-west-1"` | no |
| tfe\_workspace\_agent\_pool\_id | Agent pool ID | `string` | `null` | no |
| tfe\_workspace\_auto\_apply | Whether to automatically apply changes when a Terraform plan is successful | `bool` | `false` | no |
| tfe\_workspace\_branch | The Git branch to trigger the TFE workspace for | `string` | `"master"` | no |
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
| tfe\_workspace\_settings | TFE Workspaces settings | <pre>object({<br>    oauth_token_id         = string<br>    repository_name        = string<br>    repository_owner       = string<br>    terraform_organization = string<br>    terraform_version      = string<br>  })</pre> | `null` | no |
| tfe\_workspace\_slack\_notification\_triggers | The triggers to send to Slack | `list(string)` | <pre>[<br>  "run:created",<br>  "run:planning",<br>  "run:needs_attention",<br>  "run:applying",<br>  "run:completed",<br>  "run:errored"<br>]</pre> | no |
| tfe\_workspace\_slack\_notification\_url | The Slack Webhook URL to send notification to | `string` | `null` | no |
| tfe\_workspace\_ssh\_key\_id | The SSH key ID to assign to the workspace | `string` | `null` | no |
| tfe\_workspace\_trigger\_prefixes | List of repository-root-relative paths which should be tracked for changes | `list(string)` | <pre>[<br>  "modules"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| additional\_tfe\_workspace | Map of additional TFE workspaces containing name and workspace ID |
| id | The AWS account ID |
| tfe\_workspace\_id | The TFE workspace ID |

<!--- END_TF_DOCS --->
