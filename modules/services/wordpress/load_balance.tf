# -----------------------------------------------------------------------
# Target group
# -----------------------------------------------------------------------

resource "aws_alb_target_group" "web" {
  name     = "${var.prefix_name}-tg"
  vpc_id   = "${var.vpc_id}"
  port     = "${local.nginx_port}"
  protocol = "HTTP"

  health_check {
    path    = "/healthcheck"
    matcher = "200-302"
    timeout = "${var.healthcheck_timeout}"
  }

  stickiness {
    type = "lb_cookie"
  }
}

# -----------------------------------------------------------------------
# Main listener rule
# -----------------------------------------------------------------------

resource "aws_alb_listener_rule" "rule" {
  count = "${var.listener_count}"

  listener_arn = "${element(var.listener_arns, count.index)}"
  priority     = 1

  condition = {
    field  = "path-pattern"
    values = ["/*"]
  }

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.web.arn}"
  }
}
