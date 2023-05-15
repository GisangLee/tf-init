variable "ENV" {}
variable "PROJECT_NAME" {}

data "aws_secretsmanager_random_password" "sm-db-pwd" {
  password_length = 30
  require_each_included_type = true
}

# variable "db-config" {
#   default = {
#     username = "${var.PROJECT_NAME}"
#     password = "${aws_secretsmanager_random_password.random_password}"
#   }

#   type = map(string)
# }

resource "aws_secretsmanager_secret" "secret_manager" {
  name = "${var.PROJECT_NAME}/db/${var.ENV}"

  tags = {
    Iac  = "Terraform"
    ENV  = var.ENV
    Name = "${var.PROJECT_NAME}-${var.ENV}-db-secret"
  }
}

resource "aws_secretsmanager_secret_version" "sm-sercret-version" {
  secret_id     = aws_secretsmanager_secret.secret_manager.id
  secret_string = <<EOF
   {
    "username": "${var.PROJECT_NAME}",
    "password": "${data.aws_secretsmanager_random_password.sm-db-pwd.random_password}"
   }
   EOF
}
