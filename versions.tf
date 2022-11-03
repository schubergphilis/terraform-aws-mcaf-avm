terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    github = {
      source = "integrations/github"
    }
    mcaf = {
      source  = "schubergphilis/mcaf"
      version = ">= 0.4.2"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = ">= 0.25.0"
    }
  }
  required_version = ">= 1.3.0"
}
