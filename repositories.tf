data "aws_caller_identity" "current" {}

module "wordpress_nginx_ecr_repository" {
  source                       = "github.com/maxgio92/terraform-aws-ecr-repository?ref=1.0.0"
  name                         = "${var.app_name}/nginx"
  aws_accounts_allowed_to_pull = ["${data.aws_caller_identity.current.account_id}"]
}

module "wordpress_php_fpm_ecr_repository" {
  source                       = "github.com/maxgio92/terraform-aws-ecr-repository?ref=1.0.0"
  name                         = "${var.app_name}/php-fpm"
  aws_accounts_allowed_to_pull = ["${data.aws_caller_identity.current.account_id}"]
}

module "wordpress_php_cli_ecr_repository" {
  source                       = "github.com/maxgio92/terraform-aws-ecr-repository?ref=1.0.0"
  name                         = "${var.app_name}/php-cli"
  aws_accounts_allowed_to_pull = ["${data.aws_caller_identity.current.account_id}"]
}
