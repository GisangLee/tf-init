variable "ENV" {}
variable "AWS_REGION" {}
variable "VPC_ID" {}
variable "PROJECT_NAME" {}

# ALB 보안그룹
resource "aws_security_group" "alb-sg" {
  name   = "${var.PROJECT_NAME}-alb-sg"
  vpc_id = var.VPC_ID

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Iac  = "Terraform"
    ENV  = var.ENV
    Name = "${var.PROJECT_NAME}-${var.ENV}-alb-sg"
  }
}

# ECS 보안 그룹
resource "aws_security_group" "ecs-sg" {
  name   = "${var.PROJECT_NAME}-ecs-sg"
  vpc_id = var.VPC_ID

  ingress {
    description     = "Traffic From ALB"
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Iac  = "Terraform"
    ENV  = var.ENV
    Name = "${var.PROJECT_NAME}-${var.ENV}-ecs-sg"
  }
}

# RDS 보안그룹
resource "aws_security_group" "rds-sg" {
  name   = "${var.PROJECT_NAME}-rds-sg"
  vpc_id = var.VPC_ID

  ingress {
    description     = "Traffic From ECS"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Iac  = "Terraform"
    ENV  = var.ENV
    Name = "${var.PROJECT_NAME}-${var.ENV}-rds-sg"
  }
}