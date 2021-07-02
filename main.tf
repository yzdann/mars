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
  public_subnet_count  = 3
  cidr                 = "10.0.0.0/16"
}

module "main" {
  source = "./modules/vpc"
  name   = local.name
  cidr   = local.cidr

  azs = [for zone in local.zones : "${local.region}${zone}"]

  private_subnets = [for count in range(local.private_subnet_count) : cidrsubnet(local.cidr, 8, count)]
  public_subnets  = [for count in range(local.public_subnet_count) : cidrsubnet(local.cidr, 8, 10 + count)]

  tags = local.tags
}
