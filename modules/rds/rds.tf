resource "aws_db_instance" "db-impact" {
  identifier                   = "db-impact"
  allocated_storage            = 50
  # iops                         = 1000
  engine                       = "postgres"
  engine_version               = "15.6"
  instance_class               = var.instance_type
  db_name                      = var.name_db
  username                     = var.username_db
  password                     = var.password_db
  port                         = "5432"
  skip_final_snapshot          = true
  publicly_accessible          = true
  # performance_insights_enabled = true
  # performance_insights_kms_key_id       = aws_kms_key.kms_key.arn
  # performance_insights_retention_period = 7
  backup_retention_period               = 7
  db_subnet_group_name                  = var.db_subnet_group_name
  vpc_security_group_ids                = var.vpc_security_group_ids
  # enabled_cloudwatch_logs_exports       = ["postgresql", "upgrade"]

  tags = {
    Name = "RDS postgres"
  }
}
