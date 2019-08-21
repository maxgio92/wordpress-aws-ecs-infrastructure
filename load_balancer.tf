# -----------------------------------------------------------------------
# Public load balancer
# -----------------------------------------------------------------------

# Application load balancer

module "public_lb" {
  source = "github.com/maxgio92/terraform-aws-load-balancer?ref=1.0.0"

  subnet_ids = "${module.vpc.public_subnet_ids}"
  internal   = false

  listeners_count = 1

  listeners = [
    {
      port     = "${var.app_endpoint_public_http_port}"
      protocol = "HTTP"
    },
  ]

  security_group_public_rules_count = 1

  security_group_public_rules = [
    {
      port     = "${var.app_endpoint_public_http_port}"
      protocol = "tcp"
      source   = "0.0.0.0/0"
    },
  ]

  prefix_name = "${var.app_name}-${var.env_name}"
}

# Allow traffic from the LB to the ECS cluster

resource "aws_security_group_rule" "ecs_cluster_from_public_lb" {
  description = "Allow traffic to ${aws_security_group.ecs_cluster.name} from its public load balancer"

  type      = "ingress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"

  source_security_group_id = "${module.public_lb.security_group_id}"

  security_group_id = "${aws_security_group.ecs_cluster.id}"
}
