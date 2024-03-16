variable "vpc_security_group_ids" {
  description = "The list of VPC security group IDs"
}

variable "subnet_id" {
  description = "ID da Subnet onde a instância EC2 será lançada"
}

variable "key_name" {
  description = "impact_ssh"
}

variable "instance_type_name" {
  description = "Name fo ec2 instance"
}