variable "name" {
  description = "Name used across the resources created"
  type        = string
}

variable "use_name_prefix" {
  description = "Determines whether to use `name` as is or create a unique name beginning with the `name` as the prefix"
  type        = bool
  default     = true
}

# launch_config
variable "create_launch_config" {
  description = "Determines whether to create launch configuration or not"
  type        = bool
  default     = false
}

variable "launch_config_name" {
  description = "Determines whether to use `launch_config_name` as is or create a unique name beginning with the `lc_name` as the prefix"
  type        = string
  default     = null
}

variable "launch_config_use_name_prefix" {
  description = "Determines whether to use `launch_config_name` as is or create a unique name beginning with the `lc_name` as the prefix"
  type        = bool
  default     = true
}

variable "image_id" {
  description = "The AMI from which to launch the instance"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "The type of the instance to launch"
  type        = string
  default     = ""
}

variable "user_data" {
  description = "(LC) The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; see `user_data_base64` instead"
  type        = string
  default     = null
}

variable "security_groups" {
  description = "A list of security group IDs to associate"
  type        = list(string)
  default     = null
}

variable "associate_public_ip_address" {
  description = "(LC) Associate a public ip address with an instance in a VPC"
  type        = bool
  default     = null
}

variable "enable_monitoring" {
  description = "Enables/disables detailed monitoring"
  type        = bool
  default     = null
}

# autoscaling_group
variable "create_auto_scaling_group" {
  description = "Determines whether to create autoscaling group or not"
  type        = bool
  default     = true
}

variable "availability_zone" {
  description = "A list of one or more availability zones for the group. Used for EC2-Classic and default subnets when not specified with `vpc_zone_identifier` argument. Conflicts with `vpc_zone_identifier`"
  type        = list(string)
  default     = null
}

variable "vpc_zone_identifier" {
  description = "A list of subnet IDs to launch resources in. Subnets automatically determine which availability zones the group will reside. Conflicts with `availability_zones`"
  type        = list(string)
  default     = null
}

variable "min_size" {
  description = "The minimum size of the autoscaling group"
  type        = number
  default     = null
}

variable "max_size" {
  description = "The maximum size of the autoscaling group"
  type        = number
  default     = null
}

variable "target_group_arns" {
  description = "A set of `aws_alb_target_group` ARNs, for use with Application or Network Load Balancing"
  type        = list(string)
  default     = []
}

variable "load_balancers" {
  description = "A list of elastic load balancer names to add to the autoscaling group names. Only valid for classic load balancers. For ALBs, use `target_group_arns` instead"
  type        = list(string)
  default     = []
}

variable "health_check_type" {
  description = "`EC2` or `ELB`. Controls how health checking is done"
  type        = string
  default     = null
}
