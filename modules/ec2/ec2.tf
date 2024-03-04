resource "aws_instance" "infra_inpact" {
  ami           = "ami-0440d3b780d96b29d"
  instance_type = "t2.micro"
  vpc_security_group_ids =  var.vpc_security_group_ids

  tags = {
    Name = "impact-ec2"
  }
}