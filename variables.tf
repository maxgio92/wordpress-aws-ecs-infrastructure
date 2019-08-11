#---------------------------------------------------
# Provider 
#---------------------------------------------------

variable "aws_region" {
  default = "eu-west-1"
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

variable "ecs_cluster_instance_key_name" {
  default     = ""
  description = "The key name to use for the ECS cluster's instances"
}

variable "ecs_cluster_mount_efs" {
  default = true

  description = <<EOF
  Whether to mount an EFS filesystem on ECS cluster' instances.
  EOF
}

#---------------------------------------------------
# Application
#---------------------------------------------------

variable "app_name" {
  description = "The name of the application"
}

variable "env_name" {
  description = "The name of the application environment"
}

variable "app_service_nginx_image_version" {
  default     = "latest"
  description = "The version of the NGiNX image"
}

variable "app_service_php_fpm_image_version" {
  default     = "latest"
  description = "The version of the PHP-FPM image"
}

variable "app_endpoint_public_http_port" {
  description = <<EOF
  The port on which to communicate via HTTP to the application
  EOF
}

variable "app_service_desired_capacity" {
  default     = 4
  description = "The desired number of ECS tasks to place and keep running"
}

variable "app_service_min_capacity" {
  default     = 2
  description = "The minimum number of ECS tasks to place and keep running"
}

variable "app_service_max_capacity" {
  default     = 8
  description = "The maximum number of ECS tasks to place and keep running"
}

variable "app_service_nginx_memory_soft_limit" {
  default     = 128
  description = "The memory soft limit for the PHP-FPM container (MB)"
}

variable "app_service_php_fpm_memory_soft_limit" {
  default     = 256
  description = "The memory soft limit for the PHP-FPM container (MB)"
}

variable "app_service_db_host" {
  description = "The content database host for the application"
}

variable "app_service_db_name" {
  description = "The content database name for the application"
}

variable "app_service_db_user" {
  description = "The content database user for the application"
}

variable "app_service_db_password" {
  description = "The content database password for the application"
}
