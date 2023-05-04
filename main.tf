locals {
  workspace_name = "${var.env}-${var.projectd_name}-middle-infra"
}

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
      name = local.workspace_name
    }
  }
}


# # Configure the AWS Provider
# provider "aws" {
#   region     = "ap-northeast-2"
#   access_key = "AKIAVWTTQ7KNKDI5YLQ3"
#   secret_key = "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"
# }


