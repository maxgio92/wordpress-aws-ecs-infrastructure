# ECS Cluster (resource)
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.app_name}-${var.env_name}-cluster"
}

# Autoscaling Group (module)
module "ecs_autoscaling_group" {
  source = "./modules/infrastructure/autoscaling-group-spot"

  image_id = "${data.aws_ami.latest_ecs_optimized.id}"

  instance_profile_arn                     = "${module.ecs_instance_profile.arn}"
  instance_user_data                       = "${var.ecs_cluster_mount_efs ? data.template_file.ecs_instance_user_data_efs.rendered : data.template_file.ecs_instance_user_data.rendered}"
  instance_types                           = ["${var.ecs_cluster_instance_types}"]
  instance_key_name                        = "${var.ecs_cluster_instance_key_name}"
  on_demand_percentage_above_base_capacity = 50
  vpc_subnet_ids                           = ["${module.vpc.private_subnet_ids}"]
  vpc_security_group_ids                   = ["${aws_security_group.ecs_cluster.id}"]
}

# AMI Instance Profile for ECS (module)
module "ecs_instance_profile" {
  source = "./modules/infrastructure/ecs-instance-profile"
  name   = "ecs-instance-profile"
}

# Instance User Data for ECS (data)
data "template_file" "ecs_instance_user_data" {
  template = "${file("./templates/user-data.sh")}"

  vars {
    cluster_name = "${aws_ecs_cluster.ecs_cluster.name}"
  }
}

# ECS-optimized AMI (data)
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

# ECS Cluster's Security Groups (resources)
resource "aws_security_group" "ecs_cluster" {
  name        = "${var.app_name}-${var.env_name}-ecs-cluster"
  description = "${var.app_name} ${var.env_name} ECS cluster"

  vpc_id = "${module.vpc.vpc_id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
