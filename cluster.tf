# -----------------------------------------------------------------------
# ECS cluster
# -----------------------------------------------------------------------

# ECS cluster

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.app_name}-${var.env_name}-cluster"
}

# -----------------------------------------------------------------------
# Autoscaling group
# -----------------------------------------------------------------------

# ECS-optimized AMI

data "aws_ami" "latest_ecs_optimized" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

# AMI Instance Profile for ECS

module "ecs_instance_profile" {
  source = "./modules/infrastructure/ecs-instance-profile"
  name   = "ecs-instance-profile"
}

# Instance user data for ECS

data "template_file" "ecs_instance_user_data" {
  template = "${file("./templates/user-data.sh")}"

  vars {
    cluster_name = "${aws_ecs_cluster.ecs_cluster.name}"
  }
}

# Security group

resource "aws_security_group" "ecs_cluster" {
  name        = "${var.app_name}-${var.env_name}-ecs-cluster"
  description = "${var.app_name} ${var.env_name} ECS cluster"

  vpc_id = "${module.vpc.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "ecs_cluster_from_itself" {
  description = "Allow SSH traffic to ${aws_security_group.ecs_cluster.name} from itself"

  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  source_security_group_id = "${aws_security_group.ecs_cluster.id}"

  security_group_id = "${aws_security_group.ecs_cluster.id}"
}

# Autoscaling group

module "ecs_autoscaling_group" {
  source = "./modules/infrastructure/autoscaling-group-spot"

  image_id = "${data.aws_ami.latest_ecs_optimized.id}"

  instance_profile_arn = "${module.ecs_instance_profile.arn}"

  instance_user_data = "${var.ecs_cluster_mount_efs ?
    data.template_file.ecs_instance_user_data_efs.rendered :
    data.template_file.ecs_instance_user_data.rendered}"

  instance_types                           = ["${var.ecs_cluster_instance_types}"]
  instance_key_name                        = "${var.ecs_cluster_instance_key_name}"
  on_demand_percentage_above_base_capacity = 50
  vpc_subnet_ids                           = ["${module.vpc.private_subnet_ids}"]
  vpc_security_group_ids                   = ["${aws_security_group.ecs_cluster.id}"]
}
