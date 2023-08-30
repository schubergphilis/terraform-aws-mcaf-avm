terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.9.0"
    }
    github = {
      source  = "integrations/github"
      version = ">= 4.0.0"
    }
    mcaf = {
      source  = "schubergphilis/mcaf"
      version = ">= 0.4.2"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = ">= 0.25.0"
    }
    tls = {
      source  = "hasicorp/tls"
      version = ">= 4.0.4"
    }
  }
  required_version = ">= 1.3.0"
}
