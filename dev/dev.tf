module "toktokhan-dev-vpc" {
    source = "../modules/network"
    ENV = var.ENV
    AWS_REGION = var.AWS_REGION
    PROJECT_NAME = var.PROJECT_NAME
}


module "toktokhan-test-sg" {
    source = "../modules/sg"
    ENV = var.ENV
    AWS_REGION = var.AWS_REGION
    VPC_ID = module.toktokhan-dev-vpc.vpc_id
    PROJECT_NAME = var.PROJECT_NAME
}

module "toktokhan-test-s3" {
  source = "../modules/s3"
  ENV = var.ENV
  PROJECT_NAME = var.PROJECT_NAME
}

module "toktokhan-test-rds" {
  source = "../modules/rds"
  ENV = var.ENV
  AZ_LIST = module.toktokhan-dev-vpc.az_list
  DB_USERNAME = var.DB_USERNAME
  DB_NAME = var.DB_NAME
  DB_PWD = var.DB_PWD
  SUBNET_IDS = module.toktokhan-dev-vpc.subnet_list
  PROJECT_NAME = var.PROJECT_NAME
}