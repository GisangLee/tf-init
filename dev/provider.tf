terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.65.0"
    }
  }
  # backend "s3" { # 강의는 
  #   bucket         = module.aws_s3_bucket.backend_bucket_name # s3 bucket 이름
  #   key            = "terraform/terraform.tfstate" # s3 내에서 저장되는 경로를 의미합니다.
  #   region         = "ap-northeast-2"  
  #   encrypt        = true
  #   # dynamodb_table = "terraform-lock"
  # }
}
# Configure the AWS Provider
provider "aws" {
  region     = var.AWS_REGION
  access_key = var.AWS_ACESST_KEY
  secret_key = var.AWS_SECRET_ACCESS_KEY
}