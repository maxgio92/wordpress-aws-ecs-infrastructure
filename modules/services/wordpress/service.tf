# -----------------------------------------------------------------------
# Service 
# -----------------------------------------------------------------------

locals {
  service_name = "${var.prefix_name}-service"
}

resource "aws_ecs_service" "web" {
  name            = "${local.service_name}"
  cluster         = "${var.cluster_id}"
  desired_count   = "${var.desired_capacity}"
  task_definition = "${aws_ecs_task_definition.web.arn}"

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.web.arn}"
    container_name   = "nginx"
    container_port   = "${local.nginx_port}"
  }

  lifecycle {
    ignore_changes = ["desired_count"]
  }
}
