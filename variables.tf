variable "aws_region" {
  default = "eu-west-1"
}

variable "app_name" {
  description = "The name of the application"
}

variable "env_name" {
  description = "The name of the application environment"
}

#---------------------------------------------------
# Network
#---------------------------------------------------

variable "network_cidr" {
  description = "The CIDR block of the network"
}

variable "network_public_subnet_count" {
  description = "How much public subnets to create"
}

variable "network_public_subnet_mask_newbits" {
  description = <<EOF
  The number of bits of the public subnet mask to add
  to the ones of the network's subnet mask.
  E.g: network's CIDR block: 10.0.0.0/8 (8 bits subnet mask);
  public subnet's CIDR block: 10.0.0.0/16 (16 bits 
  subnet mask, 8 new bits).
  EOF
}

variable "network_private_subnet_count" {
  description = "How much private subnets to create"
}

variable "network_private_subnet_mask_newbits" {
  description = <<EOF
  The number of bits of the private subnet mask to add
  to the ones of the network's subnet mask.
  E.g: network's CIDR block: 10.0.0.0/8 (8 bits subnet mask);
  private subnet's CIDR block: 10.0.0.0/16 (16 bits 
  subnet mask, 8 new bits).
  EOF
}

#---------------------------------------------------
# ECS cluster
#---------------------------------------------------

variable "ecs_cluster_instance_types" {
  type = "list"

  description = <<EOF
  A list of 2 instance types for the ECS cluster.
  The list is prioritized: instances at the top of the list
  will be used in preference to those lower down.
  EOF
}
