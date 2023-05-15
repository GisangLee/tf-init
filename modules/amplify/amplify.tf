variable "ENV" {}
variable "PROJECT_NAME" {}
variable "REPO_URL" {}

resource "aws_amplify_app" "amplify-app" {
  name = "${var.PROJECT_NAME}-${var.ENV}-app"
  repository = "${var.REPO_URL}"
  tags = {
    Iac  = "Terraform"
    ENV  = var.ENV
    Name = "${var.PROJECT_NAME}-${var.ENV}-amplify-app"
  }
}