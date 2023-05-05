variable "ENV" {}
variable "AWS_REGION" {}
variable "VPC_ID" {}

module "toktokhan-dev-vpc" {
    source = "../network"
    ENV = var.ENV
    AWS_REGION = var.AWS_REGION
}

# ALB 보안그룹
resource "aws_security_group" "toktokhan-test-alb-sg" {
  name        = "toktokhan-test-alb-sg"
  vpc_id      = var.VPC_ID

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTPS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Iac = "Terraform"
    ENV = var.ENV
    Name = "toktokhan-test-${var.ENV}-alb-sg"
  }
}

# ECS 보안 그룹
resource "aws_security_group" "toktokhan-test-ecs-sg" {
  name        = "toktokhan-test-ecs-sg"
  vpc_id      = var.VPC_ID

  ingress {
    description      = "Traffic From ALB"
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    security_groups      = [aws_security_group.toktokhan-test-alb-sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Iac = "Terraform"
    ENV = var.ENV
    Name = "toktokhan-test-${var.ENV}-ecs-sg"
  }
}

# RDS 보안그룹
resource "aws_security_group" "toktokhan-test-rds-sg" {
  name        = "toktokhan-test-rds-sg"
  vpc_id      = var.VPC_ID

  ingress {
    description      = "Traffic From ECS"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    security_groups      = [aws_security_group.toktokhan-test-ecs-sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Iac = "Terraform"
    ENV = var.ENV
    Name = "toktokhan-test-${var.ENV}-rds-sg"
  }
}