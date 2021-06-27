terraform {
  required_version = "1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

locals {
  name = "main"
  tags = {
    Owner = "yazdan"
    Env   = "dev"
  }
}

module "main" {
  source = "./modules/vpc"

  name = local.name
  cidr = "10.0.0.0/16"

  tags = local.tags
}
