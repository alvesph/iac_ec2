provider "aws" {
  region = var.region
}

module "rede_and_security" {
  source      = "./modules/rede_and_security"
  allowed_ips = var.allowed_ips
}

module "rds" {
  source                 = "./modules/rds"
  instance_type          = var.instance_type
  username_db            = var.username_db
  password_db            = var.password_db
  db_subnet_group_name   = module.rede_and_security.db_subnet_group_name
  vpc_security_group_ids = [module.rede_and_security.rds_postgres_sg_id]
}

module "ec2" {
  source                 = "./modules/ec2"
  vpc_security_group_ids = [module.rede_and_security.application_sg_id]
}
