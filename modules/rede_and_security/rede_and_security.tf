resource "aws_vpc" "vpc-main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "VPC main"
  }
}

resource "aws_subnet" "impact-a" {
  vpc_id                  = aws_vpc.vpc-main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "impact-a"
  }
}

resource "aws_subnet" "impact-b" {
  vpc_id                  = aws_vpc.vpc-main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "impact-b"
  }
}

resource "aws_subnet" "impact-c" {
  vpc_id                  = aws_vpc.vpc-main.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "impact-c"
  }
}

# resource "aws_subnet" "impact-a-public" {
#   vpc_id                  = aws_vpc.vpc-main.id
#   cidr_block              = "10.0.4.0/24"
#   availability_zone       = "us-east-1a"
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "public-a"
#   }
# }

# resource "aws_subnet" "impact-b-public" {
#   vpc_id                  = aws_vpc.vpc-main.id
#   cidr_block              = "10.0.5.0/24"
#   availability_zone       = "us-east-1b"
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "public-b"
#   }
# }

# resource "aws_subnet" "impact-c-public" {
#   vpc_id                  = aws_vpc.vpc-main.id
#   cidr_block              = "10.0.6.0/24"
#   availability_zone       = "us-east-1c"
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "public-c"
#   }
# }
resource "aws_db_subnet_group" "db_subnet_group" {
  name        = "db-subnet-group"
  description = "Subnet group for RDS in homolog environment"

  subnet_ids = [
    aws_subnet.impact-a.id,
    aws_subnet.impact-b.id,
    aws_subnet.impact-c.id,
  ]
}

resource "aws_internet_gateway" "igw_main" {
  vpc_id = aws_vpc.vpc-main.id

  tags = {
    Name = "Igw main"
  }
}

resource "aws_route_table" "main_route_table" {
  vpc_id = aws_vpc.vpc-main.id

  tags = {
    Name = "Main Route Table"
  }
}

resource "aws_route" "main_route" {
  route_table_id         = aws_route_table.main_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_main.id
}

resource "aws_route_table_association" "subnet_association_a" {
  subnet_id      = aws_subnet.impact-a.id
  route_table_id = aws_route_table.main_route_table.id
}

resource "aws_route_table_association" "subnet_association_b" {
  subnet_id      = aws_subnet.impact-b.id
  route_table_id = aws_route_table.main_route_table.id
}

resource "aws_route_table_association" "subnet_association_c" {
  subnet_id      = aws_subnet.impact-c.id
  route_table_id = aws_route_table.main_route_table.id
}

resource "aws_security_group" "application_sg" {
  vpc_id      = aws_vpc.vpc-main.id
  name        = "application"
  description = "Security Group for the application"

  dynamic "ingress" {
    for_each = var.allowed_ips
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
      description = "Only my IP"
    }
  }

  dynamic "ingress" {
    for_each = var.allowed_ips
    content {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
      description = "Only my IP - HTTPS"

    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    description = "Outbound rules for applications"
  }

  tags = {
    Name = "application_sg"
  }
}

# resource "aws_security_group" "load_balancer_security_group" {
#   vpc_id = aws_vpc.vpc-main.id

#   ingress {
#     from_port        = 80
#     to_port          = 80
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     description = "Inbound rules for loadbalancer"
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     description = "Outbound rules for loadbalancer"
#   }
#   tags = {
#     Name        = "loadbalancer_sg"
#   }
# }

resource "aws_security_group" "rds_postgres_sg" {
  vpc_id      = aws_vpc.vpc-main.id
  name        = "rds_postgres"
  description = "Security Group for RDS PostgreSQL"

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"

    security_groups = [
      aws_security_group.application_sg.id,
    ]

    description = "Allow access from Application SG"
  }

  dynamic "ingress" {
    for_each = var.allowed_ips
    content {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
      description = "Allow access from My IP"
    }
  }

  dynamic "ingress" {
    for_each = var.allowed_ips
    content {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = [ingress.value]
      description = "Allow inbound all traffic from My IP"
    }
  }

  dynamic "egress" {
    for_each = var.allowed_ips
    content {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = [egress.value]
      description = "Allow outbound all trafic from My IP"
    }
  }
  tags = {
    Name = "rds_postgres_sg"
  }
}

output "aws_vpc_main_id" {
  value = aws_vpc.vpc-main.id
}
output "db_subnet_group_name" {
  value = aws_db_subnet_group.db_subnet_group.name
}

output "rds_postgres_sg_id" {
  value = aws_security_group.rds_postgres_sg.id
}

output "application_sg_id" {
  value = aws_security_group.application_sg.id
}

output "subnet_impact_a_id" {
  value = aws_subnet.impact-a.id
}

output "subnet_impact_b_id" {
  value = aws_subnet.impact-b.id
}

output "subnet_impact_c_id" {
  value = aws_subnet.impact-c.id
}

# output "loadbalancer_sg_id" {
#   value = aws_security_group.load_balancer_security_group.id
# }