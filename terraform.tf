terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.9.0"
    }
    mcaf = {
      source  = "schubergphilis/mcaf"
      version = ">= 0.4.2"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = ">= 0.67.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0.4"
    }
  }
  required_version = ">= 1.9.0"
}
