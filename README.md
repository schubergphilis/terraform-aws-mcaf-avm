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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | >= 0.25.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.account"></a> [aws.account](#provider\_aws.account) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_account"></a> [account](#module\_account) | github.com/schubergphilis/terraform-aws-mcaf-account | v0.5.0 |
| <a name="module_additional_tfe_workspaces"></a> [additional\_tfe\_workspaces](#module\_additional\_tfe\_workspaces) | github.com/schubergphilis/terraform-aws-mcaf-workspace | v0.7.1 |
| <a name="module_tfe_workspace"></a> [tfe\_workspace](#module\_tfe\_workspace) | github.com/schubergphilis/terraform-aws-mcaf-workspace | v0.7.1 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_account_alias.alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_account_alias) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_settings"></a> [account\_settings](#input\_account\_settings) | Account settings | <pre>object({<br>    alias_prefix        = string<br>    email               = string<br>    environment         = string<br>    organizational_unit = string<br>    sso_email           = string<br>    sso_firstname       = string<br>    sso_lastname        = string<br>  })</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the account | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to resource | `map(string)` | n/a | yes |
| <a name="input_additional_tfe_workspaces"></a> [additional\_tfe\_workspaces](#input\_additional\_tfe\_workspaces) | Additional TFE Workspaces | <pre>map(object({<br>    agent_pool_id                  = string<br>    auto_apply                     = bool<br>    branch                         = string<br>    clear_text_env_variables       = map(string)<br>    clear_text_hcl_variables       = map(string)<br>    clear_text_terraform_variables = map(string)<br>    execution_mode                 = string<br>    file_triggers_enabled          = bool<br>    global_remote_state            = bool<br>    oauth_token_id                 = string<br>    policy                         = string<br>    policy_arns                    = list(string)<br>    remote_state_consumer_ids      = set(string)<br>    repository_identifier          = string<br>    sensitive_env_variables        = map(string)<br>    sensitive_hcl_variables        = map(object({ sensitive = string }))<br>    sensitive_terraform_variables  = map(string)<br>    slack_notification_triggers    = list(string)<br>    slack_notification_url         = string<br>    ssh_key_id                     = string<br>    terraform_organization         = string<br>    terraform_version              = string<br>    trigger_prefixes               = list(string)<br>    username                       = string<br>    working_directory              = string<br>  }))</pre> | `{}` | no |
| <a name="input_region"></a> [region](#input\_region) | The default region of the account | `string` | `"eu-west-1"` | no |
| <a name="input_tfe_workspace_agent_pool_id"></a> [tfe\_workspace\_agent\_pool\_id](#input\_tfe\_workspace\_agent\_pool\_id) | Agent pool ID | `string` | `null` | no |
| <a name="input_tfe_workspace_auto_apply"></a> [tfe\_workspace\_auto\_apply](#input\_tfe\_workspace\_auto\_apply) | Whether to automatically apply changes when a Terraform plan is successful | `bool` | `false` | no |
| <a name="input_tfe_workspace_branch"></a> [tfe\_workspace\_branch](#input\_tfe\_workspace\_branch) | The Git branch to trigger the TFE workspace for | `string` | `"master"` | no |
| <a name="input_tfe_workspace_clear_text_env_variables"></a> [tfe\_workspace\_clear\_text\_env\_variables](#input\_tfe\_workspace\_clear\_text\_env\_variables) | An optional map with clear text environment variables | `map(string)` | `{}` | no |
| <a name="input_tfe_workspace_clear_text_hcl_variables"></a> [tfe\_workspace\_clear\_text\_hcl\_variables](#input\_tfe\_workspace\_clear\_text\_hcl\_variables) | An optional map with clear text HCL Terraform variables | `map(string)` | `{}` | no |
| <a name="input_tfe_workspace_clear_text_terraform_variables"></a> [tfe\_workspace\_clear\_text\_terraform\_variables](#input\_tfe\_workspace\_clear\_text\_terraform\_variables) | An optional map with clear text Terraform variables | `map(string)` | `{}` | no |
| <a name="input_tfe_workspace_execution_mode"></a> [tfe\_workspace\_execution\_mode](#input\_tfe\_workspace\_execution\_mode) | Which TFE workspace execution mode to use | `string` | `"remote"` | no |
| <a name="input_tfe_workspace_file_triggers_enabled"></a> [tfe\_workspace\_file\_triggers\_enabled](#input\_tfe\_workspace\_file\_triggers\_enabled) | Whether to filter runs based on the changed files in a VCS push | `bool` | `true` | no |
| <a name="input_tfe_workspace_name"></a> [tfe\_workspace\_name](#input\_tfe\_workspace\_name) | Custom workspace name (overrides var.name) | `string` | `null` | no |
| <a name="input_tfe_workspace_policy"></a> [tfe\_workspace\_policy](#input\_tfe\_workspace\_policy) | The policy to attach to the pipeline user | `string` | `null` | no |
| <a name="input_tfe_workspace_policy_arns"></a> [tfe\_workspace\_policy\_arns](#input\_tfe\_workspace\_policy\_arns) | A set of policy ARNs to attach to the pipeline user | `list(string)` | <pre>[<br>  "arn:aws:iam::aws:policy/AdministratorAccess"<br>]</pre> | no |
| <a name="input_tfe_workspace_sensitive_env_variables"></a> [tfe\_workspace\_sensitive\_env\_variables](#input\_tfe\_workspace\_sensitive\_env\_variables) | An optional map with sensitive environment variables | `map(string)` | `{}` | no |
| <a name="input_tfe_workspace_sensitive_hcl_variables"></a> [tfe\_workspace\_sensitive\_hcl\_variables](#input\_tfe\_workspace\_sensitive\_hcl\_variables) | An optional map with sensitive HCL Terraform variables | <pre>map(object({<br>    sensitive = string<br>  }))</pre> | `{}` | no |
| <a name="input_tfe_workspace_sensitive_terraform_variables"></a> [tfe\_workspace\_sensitive\_terraform\_variables](#input\_tfe\_workspace\_sensitive\_terraform\_variables) | An optional map with sensitive Terraform variables | `map(string)` | `{}` | no |
| <a name="input_tfe_workspace_settings"></a> [tfe\_workspace\_settings](#input\_tfe\_workspace\_settings) | TFE Workspaces settings | <pre>object({<br>    global_remote_state       = bool<br>    oauth_token_id            = string<br>    remote_state_consumer_ids = set(string)<br>    repository_identifier     = string<br>    terraform_organization    = string<br>    terraform_version         = string<br>    working_directory         = string<br>  })</pre> | `null` | no |
| <a name="input_tfe_workspace_slack_notification_triggers"></a> [tfe\_workspace\_slack\_notification\_triggers](#input\_tfe\_workspace\_slack\_notification\_triggers) | The triggers to send to Slack | `list(string)` | <pre>[<br>  "run:created",<br>  "run:planning",<br>  "run:needs_attention",<br>  "run:applying",<br>  "run:completed",<br>  "run:errored"<br>]</pre> | no |
| <a name="input_tfe_workspace_slack_notification_url"></a> [tfe\_workspace\_slack\_notification\_url](#input\_tfe\_workspace\_slack\_notification\_url) | The Slack Webhook URL to send notification to | `string` | `null` | no |
| <a name="input_tfe_workspace_ssh_key_id"></a> [tfe\_workspace\_ssh\_key\_id](#input\_tfe\_workspace\_ssh\_key\_id) | The SSH key ID to assign to the workspace | `string` | `null` | no |
| <a name="input_tfe_workspace_trigger_prefixes"></a> [tfe\_workspace\_trigger\_prefixes](#input\_tfe\_workspace\_trigger\_prefixes) | List of repository-root-relative paths which should be tracked for changes | `list(string)` | <pre>[<br>  "modules"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_additional_tfe_workspace"></a> [additional\_tfe\_workspace](#output\_additional\_tfe\_workspace) | Map of additional TFE workspaces containing name and workspace ID |
| <a name="output_id"></a> [id](#output\_id) | The AWS account ID |
| <a name="output_tfe_workspace_id"></a> [tfe\_workspace\_id](#output\_tfe\_workspace\_id) | The TFE workspace ID |

<!--- END_TF_DOCS --->
