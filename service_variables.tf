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
