terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

module "ecommerce" {
  source = "./modules/ecommerce"
  alb_sgs = [module.networking.ecommerce_sg_id]
  alb_subnets = [module.networking.ecommerce_prod_subnet1_id, module.networking.ecommerce_prod_subnet2_id]
  vpc_id = module.networking.ecommerce_prod_vpc_id
}

module "networking" {
  source = "./modules/networking"
}

module "db" {
  source = "./modules/db"
  db_username = var.db_username
  db_password = var.db_password
}