resource "aws_instance" "infra_inpact" {
  ami                     = "ami-0440d3b780d96b29d"
  instance_type           = "t2.micro"
  vpc_security_group_ids  = var.vpc_security_group_ids
  subnet_id               = var.subnet_id
  key_name                = var.key_name
  tags = {
    Name = "impact-ec2"
  }
}