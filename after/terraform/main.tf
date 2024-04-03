terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

module "ecommerce" {
  source = "./modules/ecommerce"
  alb_sgs = [module.networking.ecommerce_sg_id]
  security_groups_dev = [module.networking.ecommerce_dev_sg_id]
  alb_subnets = [module.networking.ecommerce_prd_subnet1_id, module.networking.ecommerce_prd_subnet2_id]
  vpc_id = module.networking.ecommerce_prd_vpc_id
  subnet_prd_1_id = module.networking.ecommerce_prd_subnet1_id
  subnet_prd_2_id = module.networking.ecommerce_prd_subnet2_id
  subnet_dev_id = module.networking.ecommerce_dev_subnet_id
}

module "networking" {
  source = "./modules/networking"
}

module "db" {
  source = "./modules/db"
  db_username = var.db_username
  db_password = var.db_password
}

module "blog" {
  source = "./modules/blog"
  vpc_id = module.networking.blog_prd_vpc_id
  subnet_prd_id = module.networking.blog_prd_subnet_id
  subnet_dev_id = module.networking.blog_dev_subnet_id
  security_groups = [module.networking.blog_sg_id]
  security_groups_dev = [module.networking.blog_dev_sg_id]
}

module "finops" {
  source = "./modules/finops"
  alert_mail_recvr = var.alert_mail_recvr
}

module "s3" {
  source = "./modules/s3"
}