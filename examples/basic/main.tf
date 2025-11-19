provider "aws" {
  region = "eu-west-1"
}

provider "mcaf" {
  aws {}
}

provider "tfe" {
  organization = "myorg"
}

module "aws_account" {
  source = "../.."
  name   = "my-aws-account"

  account = {
    email               = "my-aws-account@email.com"
    environment         = "prod"
    organizational_unit = "Production"
    sso_email           = "control-tower-admin@company.com"
  }

  tfe_workspace = {
    default_region        = "eu-west-1"
    repository_identifier = "myorg/myworkspacerepo"
    vcs_oauth_token_id    = "oauth-token-id"
  }
}
