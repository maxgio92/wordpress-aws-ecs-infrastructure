#---------------------------------------------------
# ECS cluster
#---------------------------------------------------

variable "ecs_cluster_instance_types" {
  type = "list"

  description = <<EOF
  A list of 2 instance types for the ECS cluster.
  The list is prioritized: instances at the top of the list
  will be used in preference to those lower down.
  EOF
}

variable "ecs_cluster_instance_key_name" {
  default     = ""
  description = "The key name to use for the ECS cluster's instances"
}

variable "ecs_cluster_mount_efs" {
  default = true

  description = <<EOF
  Whether to mount an EFS filesystem on ECS cluster' instances.
  EOF
}
