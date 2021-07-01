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
  region  = local.region
}

locals {
  name = "main"
  tags = {
    Owner = "yazdan"
    Env   = "dev"
  }
  region               = "us-west-2"
  zones                = ["a", "b", "c"]
  private_subnet_count = 3
  cidr                 = "10.0.0.0/16"
}

module "main" {
  source = "./modules/vpc"
  name   = local.name
  cidr   = local.cidr

  azs = [for zone in local.zones : "${local.region}${zone}"]

  private_subnets = [for count in range(local.private_subnet_count) : cidrsubnet(local.cidr, 8, 5 * count)]

  tags = local.tags
}
