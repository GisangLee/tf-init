data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "../../module/network/outputs.tf"
  }
}

module "sg" {
    source = "../../modules/sg"
    ENV = var.ENV
    AWS_REGION = var.AWS_REGION
    # VPC_ID = module.vpc.vpc_id
    VPC_ID = data.terraform_remote_state.vpc.vpc.outputs.vpc_id
    PROJECT_NAME = var.PROJECT_NAME
}