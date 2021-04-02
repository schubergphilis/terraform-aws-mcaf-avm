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
    email               = "my-aws-account@email.com"
    environment         = "prod"
    organizational_unit = "Production"
    sso_email           = "control-tower-admin@schubergphilis.com"
    sso_firstname       = "AWS Control Tower"
    sso_lastname        = "Admin"
  }

  tfe_workspace_settings = {
    github_organization    = "schubergphilis"
    github_repository      = "terraform-aws-mcaf-avm"
    oauth_token_id         = var.oauth_token_id
    terraform_organization = "schubergphilis"
    terraform_version      = "0.14.6"
  }
}
```

### Additional workspaces

```hcl
module "aws_account" {
  source = "github.com/schubergphilis/terraform-aws-mcaf-avm?ref=VERSION"

  name = "my-aws-account"

  account_settings = {
    email               = "my-aws-account@email.com"
    environment         = "prod"
    organizational_unit = "Production"
    sso_email           = "control-tower-admin@schubergphilis.com"
    sso_firstname       = "AWS Control Tower"
    sso_lastname        = "Admin"
  }

  tfe_workspace_settings = {
    github_organization    = "schubergphilis"
    github_repository      = "terraform-aws-mcaf-avm"
    oauth_token_id         = var.oauth_token_id
    terraform_organization = "schubergphilis"
    terraform_version      = "0.14.6"
  }

  additional_tfe_workspaces = [
    {
      auto_apply                     = true
      branch                         = "master"
      clear_text_env_variables       = {}
      clear_text_terraform_variables = {}
      create_repository              = false
      github_organization            = "schubergphilis"
      github_repository              = "terraform-aws-mcaf-account-baseline"
      kms_key_id                     = null
      name                           = "my-aws-account-baseline"
      oauth_token_id                 = var.oauth_token_id
      policy_arns                    = ["arn:aws:iam::aws:policy/AdministratorAccess"]
      sensitive_env_variables        = {}
      sensitive_terraform_variables  = {}
      ssh_key_id                     = null
      terraform_organization         = "schubergphilis"
      terraform_version              = "0.14.6"
      trigger_prefixes               = null
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
| additional\_tfe\_workspaces | Additional TFE Workspaces | <pre>map(object({<br>    agent_pool_id = string<br>    auto_apply    = bool<br>    branch        = string<br>    branch_protection = list(object({<br>      branches          = list(string)<br>      enforce_admins    = bool<br>      push_restrictions = list(string)<br><br>      required_reviews = object({<br>        dismiss_stale_reviews           = bool<br>        dismissal_restrictions          = list(string)<br>        required_approving_review_count = number<br>        require_code_owner_reviews      = bool<br>      })<br><br>      required_checks = object({<br>        strict   = bool<br>        contexts = list(string)<br>      })<br>    }))<br>    clear_text_env_variables       = map(string)<br>    clear_text_hcl_variables       = map(string)<br>    clear_text_terraform_variables = map(string)<br>    create_backend_config          = bool<br>    create_repository              = bool<br>    connect_vcs_repo               = bool<br>    delete_branch_on_merge         = bool<br>    file_triggers_enabled          = bool<br>    github_admins                  = list(string)<br>    github_organization            = string<br>    github_readers                 = list(string)<br>    github_repository              = string<br>    github_writers                 = list(string)<br>    kms_key_id                     = string<br>    oauth_token_id                 = string<br>    policy                         = string<br>    policy_arns                    = list(string)<br>    repository_description         = string<br>    repository_visibility          = string<br>    sensitive_env_variables        = map(string)<br>    sensitive_hcl_variables        = map(object({ sensitive = string }))<br>    sensitive_terraform_variables  = map(string)<br>    slack_notification_triggers    = list(string)<br>    slack_notification_url         = string<br>    ssh_key_id                     = string<br>    terraform_organization         = string<br>    terraform_version              = string<br>    trigger_prefixes               = list(string)<br>    working_directory              = string<br>  }))</pre> | `{}` | no |
| region | The default region of the account | `string` | `"eu-west-1"` | no |
| tfe\_workspace\_agent\_pool\_id | Agent pool ID | `string` | `null` | no |
| tfe\_workspace\_auto\_apply | Whether to automatically apply changes when a Terraform plan is successful | `bool` | `false` | no |
| tfe\_workspace\_branch | The Git branch to trigger the TFE workspace for | `string` | `"master"` | no |
| tfe\_workspace\_branch\_protection | The Github branches to protect from forced pushes and deletion | <pre>list(object({<br>    branches          = list(string)<br>    enforce_admins    = bool<br>    push_restrictions = list(string)<br><br>    required_reviews = object({<br>      dismiss_stale_reviews           = bool<br>      dismissal_restrictions          = list(string)<br>      required_approving_review_count = number<br>      require_code_owner_reviews      = bool<br>    })<br><br>    required_checks = object({<br>      strict   = bool<br>      contexts = list(string)<br>    })<br>  }))</pre> | `[]` | no |
| tfe\_workspace\_clear\_text\_env\_variables | An optional map with clear text environment variables | `map(string)` | `{}` | no |
| tfe\_workspace\_clear\_text\_hcl\_variables | An optional map with clear text HCL Terraform variables | `map(string)` | `{}` | no |
| tfe\_workspace\_clear\_text\_terraform\_variables | An optional map with clear text Terraform variables | `map(string)` | `{}` | no |
| tfe\_workspace\_connect\_vcs\_repo | Whether or not to connect a VCS repo to the workspace | `bool` | `true` | no |
| tfe\_workspace\_create\_backend\_config | Whether to create a backend.tf containing the remote backend config | `bool` | `true` | no |
| tfe\_workspace\_create\_repository | Whether of not to create a new repository | `bool` | `false` | no |
| tfe\_workspace\_delete\_branch\_on\_merge | Whether or not to delete the branch after a pull request is merged | `bool` | `true` | no |
| tfe\_workspace\_file\_triggers\_enabled | Whether to filter runs based on the changed files in a VCS push | `bool` | `true` | no |
| tfe\_workspace\_github\_admins | A list of Github teams that should have admins access | `list(string)` | `[]` | no |
| tfe\_workspace\_github\_readers | A list of Github teams that should have read access | `list(string)` | `[]` | no |
| tfe\_workspace\_github\_writers | A list of Github teams that should have write access | `list(string)` | `[]` | no |
| tfe\_workspace\_kms\_key\_id | The KMS key ID used to encrypt the SSM parameters | `string` | `null` | no |
| tfe\_workspace\_name | Custom workspace name (overrides var.name) | `string` | `null` | no |
| tfe\_workspace\_policy | The policy to attach to the pipeline user | `string` | `null` | no |
| tfe\_workspace\_policy\_arns | A set of policy ARNs to attach to the pipeline user | `list(string)` | <pre>[<br>  "arn:aws:iam::aws:policy/AdministratorAccess"<br>]</pre> | no |
| tfe\_workspace\_repository\_description | A description for the Github repository | `string` | `null` | no |
| tfe\_workspace\_repository\_visibility | Make the Github repository visibility | `string` | `"private"` | no |
| tfe\_workspace\_sensitive\_env\_variables | An optional map with sensitive environment variables | `map(string)` | `{}` | no |
| tfe\_workspace\_sensitive\_hcl\_variables | An optional map with sensitive HCL Terraform variables | <pre>map(object({<br>    sensitive = string<br>  }))</pre> | `{}` | no |
| tfe\_workspace\_sensitive\_terraform\_variables | An optional map with sensitive Terraform variables | `map(string)` | `{}` | no |
| tfe\_workspace\_settings | TFE Workspaces settings | <pre>object({<br>    github_organization    = string<br>    github_repository      = string<br>    oauth_token_id         = string<br>    terraform_organization = string<br>    terraform_version      = string<br>  })</pre> | `null` | no |
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