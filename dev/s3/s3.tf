module "s3" {
  source       = "../../modules/s3"
  ENV          = var.ENV
  PROJECT_NAME = var.PROJECT_NAME
}