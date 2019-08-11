# -----------------------------------------------------------------------
# Container definitions
# -----------------------------------------------------------------------

locals {
  nginx_port             = 80
  nginx_log_group_name   = "${replace(var.prefix_name, "-", "_")}_nginx_logs"
  php_fpm_log_group_name = "${replace(var.prefix_name, "-", "_")}_php_fpm_logs"
}

data "aws_region" "current" {}

data "template_file" "web_container_definitions" {
  template = "${file("${path.module}/container_definitions/web.json")}"

  vars {
    nginx_port                   = "${local.nginx_port}"
    nginx_image_repository_uri   = "${var.nginx_image_repository_uri}"
    nginx_image_version          = "${var.nginx_image_version}"
    nginx_memory_soft_limit      = "${var.nginx_memory_soft_limit}"
    nginx_log_group_name         = "${local.nginx_log_group_name}"
    php_fpm_image_repository_uri = "${var.php_fpm_image_repository_uri}"
    php_fpm_image_version        = "${var.php_fpm_image_version}"
    php_fpm_memory_soft_limit    = "${var.php_fpm_memory_soft_limit}"
    php_fpm_log_group_name       = "${local.php_fpm_log_group_name}"
    php_fpm_db_host              = "${var.db_host}"
    php_fpm_db_name              = "${var.db_name}"
    php_fpm_db_user              = "${var.db_user}"
    php_fpm_db_password          = "${var.db_password}"
    log_group_region             = "${data.aws_region.current.name}"
    log_group_prefix             = "${var.prefix_name}"
  }
}

# -----------------------------------------------------------------------
# Task definition
# -----------------------------------------------------------------------

resource "aws_ecs_task_definition" "web" {
  family                = "${var.prefix_name}-task-definition"
  container_definitions = "${data.template_file.web_container_definitions.rendered}"

  volume {
    name      = "uploads"
    host_path = "${var.nfs_mountpoint}"
  }
}

# -----------------------------------------------------------------------
# Logs
# -----------------------------------------------------------------------

resource "aws_cloudwatch_log_group" "nginx" {
  name              = "${local.nginx_log_group_name}"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_group" "php_fpm" {
  name              = "${local.php_fpm_log_group_name}"
  retention_in_days = 1
}
