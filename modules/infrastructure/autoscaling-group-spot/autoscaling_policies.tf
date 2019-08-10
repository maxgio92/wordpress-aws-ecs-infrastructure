#---------------------------------------------------
# Scale out based on CPU average usage
#---------------------------------------------------

# Autoscaling Policy
resource "aws_autoscaling_policy" "cpu_scale_out" {
  name                   = "cpu-scale-out-policy"
  autoscaling_group_name = "${aws_autoscaling_group.main.name}"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

# Cloudwatch Alarm
resource "aws_cloudwatch_metric_alarm" "cpu_scale_out" {
  alarm_name          = "cpu-scale-out-alarm"
  alarm_description   = "CPU scale out alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "${var.scale_out_alarm_cpu_threshold}"

  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.main.name}"
  }

  actions_enabled = true
  alarm_actions   = ["${aws_autoscaling_policy.cpu_scale_out.arn}"]
}

#---------------------------------------------------
# Scale in based on CPU average usage
#---------------------------------------------------

# Autoscaling Policy
resource "aws_autoscaling_policy" "cpu_scale_in" {
  name                   = "cpu-scale-in-policy"
  autoscaling_group_name = "${aws_autoscaling_group.main.name}"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

# Cloudwatch Alarm
resource "aws_cloudwatch_metric_alarm" "cpu_scaled_in" {
  alarm_name          = "cpu-scale-in-alarm"
  alarm_description   = "CPU scale in alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "${var.scale_in_alarm_cpu_threshold}"

  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.main.name}"
  }

  actions_enabled = true
  alarm_actions   = ["${aws_autoscaling_policy.cpu_scale_in.arn}"]
}
