variable "app_domain_names" {
  type        = "list"
  description = "The domain names to associate to your application"
}

variable "app_dns_zone_name" {
  description = "The DNS zone name of your application domain names"
}

variable "app_endpoint_public_https_port" {
  description = <<EOF
  The port on which to communicate via HTTPS to the application
  EOF
}
