terraform {
  required_version = "1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
  }
}

locals {
  # Use `local.vpc_id` to give a hint to Terraform that subnets should be deleted before secondary CIDR blocks can be free!
  vpc_id = element(
    concat(
      aws_vpc.this.*.id,
      [""],
    ),
    0,
  )
}

resource "aws_vpc" "this" {
  count = var.create_vpc ? 1 : 0

  cidr_block           = var.cidr
  enable_dns_support   = var.enable_dns_hostnames
  enable_dns_hostnames = var.enable_dns_support

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
    var.vpc_tags,
  )
}

resource "aws_subnet" "private" {
  count = var.create_vpc && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  vpc_id               = local.vpc_id
  cidr_block           = var.private_subnets[count.index]
  availability_zone    = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null

  tags = merge(
    {
      "Name" = format(
        "%s-${var.private_subnet_suffix}-%s",
        var.name,
        element(var.azs, count.index),
      )
    },
    var.tags,
    var.private_subnet_tags,
  )
}

resource "aws_subnet" "public" {
  count = var.create_vpc && length(var.public_subnets) > 1 && (length(var.public_subnets) >= length(var.azs)) ? length(var.public_subnets) : 1

  vpc_id                  = local.vpc_id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id    = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    {
      "Name" = format(
        "%s-${var.public_subnet_suffix}-%s",
        var.name,
        element(var.azs, count.index),
      )
    },
    var.tags,
    var.public_subnet_tags,
  )
}

resource "aws_internet_gateway" "this" {
  count = var.create_vpc && var.create_igw && length(var.public_subnets) > 1 ? 1 : 0

  vpc_id = local.vpc_id
  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
    var.igw_tags,
  )
}
