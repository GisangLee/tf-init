# Configure the AWS Provider
provider "aws" {
  region     = var.AWS_REGION
  access_key = var.AWS_ACESST_KEY
  secret_key = var.AWS_SECRET_ACCESS_KEY
}
