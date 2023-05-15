module "vpc" {
    source = "../modules/network"
    ENV = var.ENV
    AWS_REGION = var.AWS_REGION
    PROJECT_NAME = var.PROJECT_NAME
}

module "secret_manager" {
  source = "../modules/secret_manager"
  ENV = var.ENV
  PROJECT_NAME = var.PROJECT_NAME
}

module "sg" {
    source = "../modules/sg"
    ENV = var.ENV
    AWS_REGION = var.AWS_REGION
    VPC_ID = module.vpc.vpc_id
    PROJECT_NAME = var.PROJECT_NAME
}

module "s3" {
  source = "../modules/s3"
  ENV = var.ENV
  PROJECT_NAME = var.PROJECT_NAME
}

module "rds" {
  source = "../modules/rds"
  ENV = var.ENV
  AZ_LIST = module.vpc.az_list
  DB_PWD = module.secret_manager.db-pwd
  SUBNET_IDS = module.vpc.subnet_list
  PROJECT_NAME = var.PROJECT_NAME
}