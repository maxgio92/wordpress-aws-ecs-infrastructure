module "public_lb" {
  source = "github.com/maxgio92/terraform-aws-load-balancer?ref=1.0.0"

  subnet_ids = "${module.vpc.public_subnet_ids}"
  internal   = false

  listeners_count = 1

  listeners = [
    {
      port     = 80
      protocol = "HTTP"
    },
  ]

  security_group_public_rules_count = 1

  security_group_public_rules = [
    {
      port     = 80
      protocol = "tcp"
      source   = "0.0.0.0/0"
    },
  ]

  prefix_name = "${var.app_name}-${var.env_name}"
}
