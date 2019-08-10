# Mount EFS on ECS cluster's instances
data "template_file" "ecs_instance_user_data_efs" {
  template = "${file("./templates/user-data-efs.sh")}"

  vars {
    cluster_name = "${aws_ecs_cluster.ecs_cluster.name}"
    efs_dns_name = "${module.efs.dns_name}"
  }
}

module "efs" {
  source = "github.com/maxgio92/terraform-aws-efs?ref=1.0.0"

  vpc_id                     = "${module.vpc.vpc_id}"
  allowed_security_groups    = ["${aws_security_group.ecs_cluster.id}"]
  mount_target_subnets_count = "${var.network_private_subnet_count}"
  mount_target_subnets       = "${module.vpc.private_subnet_ids}"
  prefix_name                = "${var.app_name}-${var.env_name}"
}
