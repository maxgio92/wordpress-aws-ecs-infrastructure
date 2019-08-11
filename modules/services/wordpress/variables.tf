variable "vpc_id" {
  description = "The VPC that the cluster is deployed to"
}

variable "cluster_id" {
  description = "The ID of the cluster that the service should run on"
}

variable "cluster_name" {
  description = "The name of the cluster that the service should run on"
}

variable "desired_capacity" {
  description = "The number of tasks to place and keep running"
  default     = 1
}

variable "min_capacity" {
  description = "The minimum number of tasks to place and keep running"
  default     = 1
}

variable "max_capacity" {
  description = "The maximum number of tasks to place and keep running"
  default     = 2
}

variable "create_autoscaling_role" {
  default     = false
  description = "Whether to create a custom autoscaling IAM role for the service"
}

variable "healthcheck_timeout" {
  default = 5
}

variable "nginx_memory_soft_limit" {
  description = "The soft limit (in MiB) of memory to reserve for the NGiNX container"
  default     = "128"
}

variable "php_fpm_memory_soft_limit" {
  description = "The soft limit (in MiB) of memory to reserve for the PHP-FPM container"
  default     = "256"
}

variable "listener_count" {
  default = 1
}

variable "listener_arns" {
  type        = "list"
  description = "A list containing the ARN of the ALB listeners to register with"
}

variable "nginx_image_repository_uri" {
  description = "The URI of the NGiNX image repository"
}

variable "nginx_image_version" {
  description = "The version tag of the NGiNX image"
}

variable "php_fpm_image_repository_uri" {
  description = "The URI of the PHP-FPM image repository"
}

variable "php_fpm_image_version" {
  description = "The version tag of the PHP-FPM image"
}

variable "db_host" {
  description = "The host of the content database"
}

variable "db_name" {
  description = "The name of the content database"
}

variable "db_user" {
  description = "The user to connect to the content database"
}

variable "db_password" {
  description = "The password to connect to the content database"
}

variable "nfs_mountpoint" {
  default = "/efs"

  description = <<EOF
  The mount point of a network filesystem on the cluster for storage to persist
  (e.g.: Wordpress' wp-content/uploads data).
  EOF
}

variable "prefix_name" {
  description = "The prefix for the name of the resources"
  default     = "my"
}
