data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "../../module/network/outputs.tf"
  }
}

data "terraform_remote_state" "sm" {
  backend = "local"

  config = {
    path = "../../module/secret_manager/outputs.tf"
  }
}

module "rds" {
  source = "../../modules/rds"
  ENV = var.ENV
  # AZ_LIST = module.vpc.az_list
  AZ_LIST = data.terraform_remote_state.vpc.outputs.az_list
  DB_PWD = data.terraform_remote_state.sm.outputs.db-pwd
  SUBNET_IDS = data.terraform_remote_state.vpc.outputs.subnet_list
  # DB_PWD = module.secret_manager.db-pwd
  # SUBNET_IDS = module.vpc.subnet_list
  PROJECT_NAME = var.PROJECT_NAME
}