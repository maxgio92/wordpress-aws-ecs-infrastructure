locals {
  database_name = "${coalesce(
    "${var.app_name}_${var.env_name}",
    var.database_name
  )}"

  database_username = "${coalesce(
    "${var.app_name}_${var.env_name}",
    var.database_username
  )}"

  # Ugly workaround to: https://github.com/hashicorp/terraform/issues/11566

  database_instance_parameter_group_name = "${coalesce(
    var.database_instance_parameter_group_name,
    join(" ", aws_db_instance_parameter_group.custom.*.id))
  }"
  database_cluster_parameter_group_name = "${coalesce(
    var.database_cluster_parameter_group_name,
    join(" ", aws_rds_cluster_parameter_group.custom.*.id))
  }"
}

# -----------------------------------------------------------------------
# Database cluster
# -----------------------------------------------------------------------

module "database" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "1.15.0"

  name                            = "${var.app_name}-${var.env_name}-db"
  engine                          = "${var.database_engine}"
  engine_version                  = "${var.database_engine_version}"
  db_parameter_group_name         = "${local.database_instance_parameter_group_name}"
  db_cluster_parameter_group_name = "${local.database_cluster_parameter_group_name}"
  vpc_id                          = "${module.vpc.vpc_id}"
  subnets                         = "${module.vpc.private_subnet_ids}"
  instance_type                   = "${var.database_instance_class}"
  replica_count                   = "${var.database_replica_count}"
  allowed_security_groups         = ["${aws_security_group.ecs_cluster.id}"]
  allowed_security_groups_count   = 1
  apply_immediately               = "${var.database_modifications_apply_immediately}"
  database_name                   = "${local.database_name}"
  username                        = "${local.database_username}"
}

# -----------------------------------------------------------------------
# Instance parameter group
# -----------------------------------------------------------------------

resource "aws_rds_cluster_parameter_group" "custom" {
  count = "${var.database_create_cluster_parameter_group ? 1 : 0}"

  name      = "${var.app_name}-${var.env_name}-cluster-parameter-group"
  family    = "${var.database_family}"
  parameter = ["${var.database_cluster_parameter_group_parameters}"]

  lifecycle {
    create_before_destroy = true
  }
}

# -----------------------------------------------------------------------
# Cluster parameter group
# -----------------------------------------------------------------------

resource "aws_db_parameter_group" "custom" {
  count = "${var.database_create_instance_parameter_group ? 1 : 0}"

  name      = "${var.app_name}-${var.env_name}-instance-parameter-group"
  family    = "${var.database_family}"
  parameter = ["${var.database_instance_parameter_group_parameters}"]

  lifecycle {
    create_before_destroy = true
  }
}
