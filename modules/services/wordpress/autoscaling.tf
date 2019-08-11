# -----------------------------------------------------------------------
# Autoscaling
# -----------------------------------------------------------------------

# Application Auto Scaling

# Target

resource "aws_appautoscaling_target" "web_service" {
  count        = "${var.create_autoscaling_role ? 0 : 1}"
  max_capacity = "${var.max_capacity}"
  min_capacity = "${var.min_capacity}"

  resource_id = "service/${var.cluster_name}/${aws_ecs_service.web.name}"

  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_target" "web_service_custom_role" {
  count        = "${var.create_autoscaling_role ? 1 : 0}"
  max_capacity = "${var.max_capacity}"
  min_capacity = "${var.min_capacity}"

  resource_id = "service/${var.cluster_name}/${aws_ecs_service.web.name}"

  role_arn           = "${aws_iam_role.service_autoscaling.arn}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# Policy

resource "aws_appautoscaling_policy" "web_service" {
  count              = "${var.create_autoscaling_role ? 0 : 1}"
  name               = "scale-cpu"
  name               = "scale-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "${element(aws_appautoscaling_target.web_service.*.resource_id, 0)}"
  scalable_dimension = "${element(aws_appautoscaling_target.web_service.*.scalable_dimension, 0)}"
  service_namespace  = "${element(aws_appautoscaling_target.web_service.*.service_namespace, 0)}"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 75
  }

  depends_on = ["aws_appautoscaling_target.web_service"]
}

resource "aws_appautoscaling_policy" "web_service_custom_role" {
  count              = "${var.create_autoscaling_role ? 1 : 0}"
  name               = "scale-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "${element(aws_appautoscaling_target.web_service_custom_role.*.resource_id, 0)}"
  scalable_dimension = "${element(aws_appautoscaling_target.web_service_custom_role.*.scalable_dimension, 0)}"
  service_namespace  = "${element(aws_appautoscaling_target.web_service_custom_role.*.service_namespace, 0)}"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 75
  }

  depends_on = ["aws_appautoscaling_target.web_service_custom_role"]
}

# Custom IAM role

data "aws_iam_policy_document" "app_autoscaling_trust" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["application-autoscaling.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "service_autoscaling" {
  count              = "${var.create_autoscaling_role ? 0 : 1}"
  name               = "${aws_ecs_service.web.name}-autoscale-role"
  assume_role_policy = "${data.aws_iam_policy_document.app_autoscaling_trust.json}"
}

data "aws_iam_policy_document" "service_autoscaling" {
  statement {
    actions = [
      "ecs:DescribeServices",
      "ecs:UpdateService",
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:DeleteAlarms",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role_policy" "service_autoscaling" {
  count = "${var.create_autoscaling_role ? 0 : 1}"
  name  = "${aws_ecs_service.web.name}-autoscale-policy"
  role  = "${element(aws_iam_role.service_autoscaling.*.id, count.index)}"

  policy = "${data.aws_iam_policy_document.service_autoscaling.json}"
}
