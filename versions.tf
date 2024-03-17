terraform {
  required_version = ">= 0.13.1"
  backend "s3" {
    bucket = "terraform-tftate"
    key    = "infra-ec2/terraform.tfstate"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.71"
    }
  }
}