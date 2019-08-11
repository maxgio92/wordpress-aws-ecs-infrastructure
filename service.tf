# -----------------------------------------------------------------------
# Application service
# -----------------------------------------------------------------------

module "app-service" {
  source = "./modules/services/wordpress"

  vpc_id     = "${module.vpc.vpc_id}"
  cluster_id = "${aws_ecs_cluster.ecs_cluster.id}"

  desired_capacity = "${var.app_service_desired_capacity}"
  min_capacity     = "${var.app_service_min_capacity}"
  max_capacity     = "${var.app_service_max_capacity}"

  nginx_memory_soft_limit   = "${var.app_service_nginx_memory_soft_limit}"
  php_fpm_memory_soft_limit = "${var.app_service_php_fpm_memory_soft_limit}"

  listener_count = "${length(module.public_lb.plain_listener_arns) + length(module.public_lb.plain_listener_arns)}"

  listener_arns = [
    "${module.public_lb.plain_listener_arns}",
    "${module.public_lb.tls_listener_arns}",
  ]

  nginx_image_repository_uri   = "${module.wordpress_nginx_ecr_repository.url}"
  nginx_image_version          = "${var.app_service_nginx_image_version}"
  php_fpm_image_repository_uri = "${module.wordpress_php_fpm_ecr_repository.url}"
  php_fpm_image_version        = "${var.app_service_php_fpm_image_version}"

  db_host     = "${var.app_service_db_host}"
  db_name     = "${var.app_service_db_name}"
  db_user     = "${var.app_service_db_user}"
  db_password = "${var.app_service_db_password}"

  prefix_name = "${var.app_name}-${var.env_name}"
}
