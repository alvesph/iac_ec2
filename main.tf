provider "aws" {
  region = var.region
}

module "rede_and_security" {
  source = "./modules/rede_and_security"
  allowed_ips = var.allowed_ips
}