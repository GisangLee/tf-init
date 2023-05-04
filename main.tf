terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.65.0"
    }
  }

  cloud {
    hostname     = "app.terraform.io"
    organization = "dude_tf_test"

    workspaces {
      name = "${var.env}-${var.proejct_name}-middle-infra"
    }
  }
}


# Configure the AWS Provider
provider "aws" {
  region     = "ap-northeast-2"
  access_key = "AKIAVWTTQ7KNKDI5YLQ3"
  secret_key = "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"
}
