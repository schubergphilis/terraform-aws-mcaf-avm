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
<!--- END_TF_DOCS --->