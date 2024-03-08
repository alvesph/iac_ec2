provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
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
  name_db                = var.name_db
  db_subnet_group_name   = module.rede_and_security.db_subnet_group_name
  vpc_security_group_ids = [module.rede_and_security.rds_postgres_sg_id]
}

module "ec2" {
  source                 = "./modules/ec2"
  vpc_security_group_ids = [module.rede_and_security.application_sg_id]
  subnet_id              = module.rede_and_security.subnet_impact_a_id
}
