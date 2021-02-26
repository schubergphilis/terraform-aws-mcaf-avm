terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    github = {
      source = "hashicorp/github"
    }
    mcaf = {
      source = "schubergphilis/mcaf"
    }
    tfe = {
      source = "hashicorp/tfe"
    }
  }
  required_version = ">= 0.13"
}
