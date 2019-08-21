output "smtp_user_username" {
  value = "${module.smtp_server.smtp_user_username}"
}

output "smtp_user_password" {
  sensitive = true
  value     = "${module.smtp_server.smtp_user_password}"
}
