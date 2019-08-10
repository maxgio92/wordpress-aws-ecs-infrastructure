variable "desired_capacity" {
  default     = 2
  description = "The number of Amazon EC2 instances that should be running in the group"
}

variable "max_size" {
  default     = 2
  description = "The maximum size of the auto scale group"
}

variable "min_size" {
  default     = 2
  description = "The minimum size of the auto scale group"
}

variable "vpc_subnet_ids" {
  type        = "list"
  description = "A list of subnet IDs to launch resources in"
}

variable "image_id" {
  description = "The AMI ID of the autoscaling group's instances"
}

variable "instance_types" {
  type = "list"

  description = <<EOF
  A list of 2 instance types of the autoscaling group.
  The list is prioritized: instances at the top of the list
  will be used in preference to those lower down.
  EOF
}

variable "custom_instance_profile" {
  default     = true
  description = "Whether to launch instances with custom IAM instance profile"
}

variable "instance_profile_arn" {
  default     = ""
  description = "The IAM instance profile ARN to launch the autoscaling group's instances with"
}

variable "instance_user_data" {
  default     = ""
  description = "The user data to provide when launching the autoscaling group's instances"
}

variable "instance_key_name" {
  default     = ""
  description = "The key name to use for the autoscaling group instances"
}

variable "vpc_security_group_ids" {
  type = "list"

  description = <<EOF
  The list of VPC security group IDs to associate
  the autoscaling group's instances with.
  EOF
}

variable "on_demand_base_capacity" {
  default = 0

  description = <<EOF
  Absolute minimum amount of desired capacity
  that must be fulfilled by on-demand instances.
  EOF
}

variable "on_demand_percentage_above_base_capacity" {
  default = 100

  description = <<EOF
  Percentage split between on-demand and Spot
  instances above the base on-demand capacity.
  EOF
}

variable "spot_allocation_strategy" {
  default     = "lowest-price"
  description = "How to allocate capacity across the Spot pools"
}

variable "spot_instance_pools" {
  default = 2

  description = <<EOF
  Number of Spot pools per availability zone to allocate capacity.
  EC2 Auto Scaling selects the cheapest Spot pools and evenly allocates
  Spot capacity across the number of Spot pools that you specify.
  EOF
}

variable "spot_max_price" {
  default = ""

  description = <<EOF
  Maximum price per unit hour that the user is willing to pay for
  the Spot instances.
  EOF
}
