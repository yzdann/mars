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
  launch_config_name = coalesce(var.launch_config_name, var.name)
}

resource "aws_launch_configuration" "this" {
  count = var.create_launch_config ? 1 : 0

  name        = var.launch_config_use_name_prefix ? null : local.launch_config_name
  name_prefix = var.launch_config_use_name_prefix ? "${local.launch_config_name}-" : null

  image_id      = var.image_id
  instance_type = var.instance_type
  user_data     = var.user_data

  security_groups             = var.security_groups
  associate_public_ip_address = var.associate_public_ip_address

  enable_monitoring = var.enable_monitoring

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  count = var.create_auto_scaling_group ? 1 : 0

  name        = var.use_name_prefix ? null : local.launch_config_name
  name_prefix = var.use_name_prefix ? "${var.name}-" : null

  launch_configuration = aws_launch_configuration.this[0].name

  availability_zones  = var.availability_zone
  vpc_zone_identifier = var.vpc_zone_identifier

  min_size = var.min_size
  max_size = var.max_size

  load_balancers    = var.load_balancers
  target_group_arns = var.target_group_arns
  health_check_type = var.health_check_type

  lifecycle {
    create_before_destroy = true
  }
}
