variable "loadbalancer_security_group_ids" {
  description = "The list of VPC ecs security group IDs"
}

variable "subnet_ec2_ids" {
  description = "ID da Subnet onde a instância ECS será lançada"
}

variable "vpc_main_id" {
  description = "The list of VPC ID"
}

variable "project_name" {
  description = "Project name"
}