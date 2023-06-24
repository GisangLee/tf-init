variable "ENV" {}
variable "PROJECT_NAME" {}
variable "REPO_URL" {}


resource "aws_iam_role" "ecs-task-role" {
  name = "${var.PROJECT_NAME}-${var.ENV}-task-role"
  path = "/"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })


  tags = {
    IaC  = "Terraform"
    ENV  = "${var.ENV}"
    Name = "${var.PROJECT_NAME}-${var.ENV}-ecs-task-role"
  }
}



resource "aws_iam_role_policy" "ecs-task-role-policy" {
  name = "${var.PROJECT_NAME}-${var.ENV}-ecs-task-role-policy"
  role = aws_iam_role.ecs-task-role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:GetRepositoryPolicy",
            "ecr:DescribeRepositories",
            "ecr:ListImages",
            "ecr:DescribeImages",
            "ecr:BatchGetImage",
            "ecr:GetLifecyclePolicy",
            "ecr:GetLifecyclePolicyPreview",
            "ecr:ListTagsForResource",
            "ecr:DescribeImageScanFindings",
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:DeleteLogStream",
            "logs:DescribeLogStreams",
            "logs:PutLogEvents",
            "logs:PutRetentionPolicy",
            "xray:*",
            "s3:*",
            "sqs:*",
            "secretsmanager:GetResourcePolicy",
            "secretsmanager:GetSecretValue",
            "secretsmanager:DescribeSecret",
            "secretsmanager:ListSecretVersionIds",
            "secretsmanager:ListSecrets",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}





resource "aws_ecs_task_definition" "web-task-definition" {
  family                   = "${var.PROJECT_NAME}-${var.ENV}-web-family"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  task_role_arn            =  aws_iam_role.ecs-task-role.arn
  cpu                      = 1024
  memory                   = 2048
  container_definition = jsonencode(
    [
        {
            name = "web"
            image = ""
            essential = true
            portMappings = [
                {
                    containerPort = 8080
                    hostPort = 8080
                    protocol = "tcp"
                }
            ]
            entryPoint = ["sh", "-c"]
            command = ""
            environment = [
                {
                    DJANGO_SETTINGS_MODULE = "config,.settings.${var.ENV}"
                },
                {
                    REDIS_HOST = ""
                },
                {
                    ECS_IMAGE_PULL_BEHAVIOR = "prefer-cached"
                }
            ]
        },
        {
            name = "xray-daemon"
            image = "public.ecr.aws/xray/aws-xray-daemon:latest"
            essential = true
            cpu = 32
            memoryReservation = 256
            portMappings = [
                {
                    containerPort = 2000
                    hostPort = 2000
                    protocol = "udp"
                }
            ]
            environment = [
                {
                    DJANGO_SETTINGS_MODULE = "config,.settings.${var.ENV}"
                },
                {
                    REDIS_HOST = ""
                },
                {
                    ECS_IMAGE_PULL_BEHAVIOR = "prefer-cached"
                }
            ]
            logConfiguration = {
                logDriver = "awslogs"
                options = {
                    awslogs-craete-group = true
                    awslogs-group = "/ecs/xray"
                    awslogs-region = "ap-northeast-2"
                    awslogs-stream-prefix = "ecs"
                }
            }
        }
    ]
  )
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }
}



resource "aws_lb" "ecs-alb" {
  name               = "${var.PROJECT_NAME}-${var.ENV}-alb"
  internal           = false
  load_balancer_type = "application"
#   security_groups    = [aws_security_group.lb_sg.id]
#   subnets            = [for subnet in aws_subnet.public : subnet.id]
  enable_deletion_protection = false

#   access_logs {
#     bucket  = aws_s3_bucket.lb_logs.id
#     prefix  = "test-lb"
#     enabled = true
#   }

  tags = {
    IaC  = "Terraform"
    ENV  = "${var.ENV}"
    Name = "${var.PROJECT_NAME}-${var.ENV}-alb"
  }
}



resource "aws_cloudwatch_log_group" "ecs-cloudwatch-log" {
  name = "${var.PROJECT_NAME}-${var.ENV}-cw-logs"
}

resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.PROJECT_NAME}-${var.ENV}-cluster"

  configuration {
    execute_command_configuration {
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.ecs-cloudwatch-log.name
      }
    }
  }
}

resource "aws_ecs_service" "web-service" {
  name            = "${var.PROJECT_NAME}-${var.ENV}-web-service"
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.web-task-definition.arn
  desired_count   = 2
  depends_on      = [aws_iam_role_policy.ecs-task-role-policy]

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    # target_group_arn = aws_lb_target_group.foo.arn
    container_name   = "mongo"
    container_port   = 8080
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [ap-northeast-2a, ap-northeast-2b]"
  }
}