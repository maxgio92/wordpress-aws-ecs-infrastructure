locals {
  # Ugly workaround to: https://github.com/hashicorp/terraform/issues/11566
  launch_template_id = "${var.custom_instance_profile ?
    join(" ", aws_launch_template.custom_instance_profile.*.id) :
    join(" ", aws_launch_template.main.*.id)}"
}

resource "aws_launch_template" "main" {
  count         = "${var.custom_instance_profile ? 0 : 1}"
  name_prefix   = "main"
  image_id      = "${var.image_id}"
  instance_type = "${var.instance_types[0]}"
  user_data     = "${base64encode(var.instance_user_data)}"

  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]
}

resource "aws_launch_template" "custom_instance_profile" {
  count         = "${var.custom_instance_profile ? 1 : 0}"
  name_prefix   = "main"
  image_id      = "${var.image_id}"
  instance_type = "${var.instance_types[0]}"

  iam_instance_profile {
    arn = "${var.instance_profile_arn}"
  }

  user_data = "${base64encode(var.instance_user_data)}"

  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]
}

resource "aws_autoscaling_group" "main" {
  desired_capacity    = "${var.desired_capacity}"
  max_size            = "${var.max_size}"
  min_size            = "${var.min_size}"
  vpc_zone_identifier = ["${var.vpc_subnet_ids}"]

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = "${local.launch_template_id}"
        version            = "$Latest"
      }

      override {
        instance_type = "${var.instance_types[0]}"
      }

      override {
        instance_type = "${var.instance_types[1]}"
      }
    }

    instances_distribution {
      on_demand_base_capacity                  = "${var.on_demand_base_capacity}"
      on_demand_percentage_above_base_capacity = "${var.on_demand_percentage_above_base_capacity}"
      spot_allocation_strategy                 = "${var.spot_allocation_strategy}"
      spot_instance_pools                      = "${var.spot_instance_pools}"
      spot_max_price                           = "${var.spot_max_price}"
    }
  }
}
