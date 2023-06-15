module "vpc" {
  source       = "../../modules/network"
  ENV          = var.ENV
  AWS_REGION   = var.AWS_REGION
  PROJECT_NAME = var.PROJECT_NAME
}