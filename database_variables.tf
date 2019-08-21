variable "database_create_cluster_parameter_group" {
  default = false
}

variable "database_create_instance_parameter_group" {
  default = false
}

variable "database_cluster_parameter_group_name" {
  default = "default.aurora-mysql5.7"
}

variable "database_cluster_parameter_group_parameters" {
  default = []
}

variable "database_engine" {
  default = "aurora-mysql"
}

variable "database_engine_version" {
  default = "5.7.12"
}

variable "database_family" {
  default = "aurora-mysql5.7"
}

variable "database_instance_class" {
  default = "db.t2.small"
}

variable "database_instance_parameter_group_name" {
  default = "default.aurora-mysql5.7"
}

variable "database_instance_parameter_group_parameters" {
  default = []
}

variable "database_modifications_apply_immediately" {
  default = false
}

variable "database_name" {
  default = ""
}

variable "database_replica_count" {
  default = 2
}

variable "database_username" {
  default = ""
}
