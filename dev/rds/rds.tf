module "rds" {
  source = "../../modules/rds"
  ENV = var.ENV
  AZ_LIST = module.vpc.az_list
  DB_PWD = module.secret_manager.db-pwd
  SUBNET_IDS = module.vpc.subnet_list
  PROJECT_NAME = var.PROJECT_NAME
}