variable "instance_type" {
  type = string
}

variable "username_db" {
  type = string
}

variable "password_db" {
  type = string
}

variable "db_subnet_group_name" {
  description = "The name of the DB subnet group"
}

variable "vpc_security_group_ids" {
  description = "The list of VPC security group IDs"
}