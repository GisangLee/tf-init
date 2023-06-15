module "sg" {
    source = "../../modules/sg"
    ENV = var.ENV
    AWS_REGION = var.AWS_REGION
    VPC_ID = module.vpc.vpc_id
    PROJECT_NAME = var.PROJECT_NAME
}