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

module "vpc" {
  source = "./modules/vpc"
  name   = local.name
  cidr   = local.cidr

  azs = [for zone in local.zones : "${local.region}${zone}"]

  private_subnets = [for count in range(local.private_subnet_count) : cidrsubnet(local.cidr, 8, count)]
  public_subnets  = [for count in range(local.public_subnet_count) : cidrsubnet(local.cidr, 8, 10 + count)]

  tags = local.tags
}

module "asg" {
  source               = "./modules/asg"
  name                 = local.name
  create_launch_config = true

  image_id            = "ami-03d5c68bab01f3496"
  instance_type       = "t2.micro"
  user_data           = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8000 & 
              EOF
  vpc_zone_identifier = module.vpc.private_subnets
  min_size            = 2
  max_size            = 5
  health_check_type   = "ELB"
}
