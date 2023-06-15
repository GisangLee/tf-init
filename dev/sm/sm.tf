module "secret_manager" {
  source = "../../modules/secret_manager"
  ENV = var.ENV
  PROJECT_NAME = var.PROJECT_NAME
}