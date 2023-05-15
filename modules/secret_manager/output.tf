output "db-pwd" {
  description = "Random Password of RDS"
  value       = data.aws_secretsmanager_random_password.sm-db-pwd.random_password
}
