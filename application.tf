# -----------------------------------------------------------------------
# Application service
# -----------------------------------------------------------------------

module "app_service" {
  source = "./modules/services/wordpress"

  vpc_id       = "${module.vpc.vpc_id}"
  cluster_id   = "${aws_ecs_cluster.ecs_cluster.id}"
  cluster_name = "${aws_ecs_cluster.ecs_cluster.name}"

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

  db_host     = "${module.database.this_rds_cluster_endpoint}"
  db_name     = "${module.database.this_rds_cluster_database_name}"
  db_user     = "${module.database.this_rds_cluster_master_username}"
  db_password = "${module.database.this_rds_cluster_master_password}"

  prefix_name = "${var.app_name}-${var.env_name}"
}
