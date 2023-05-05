output "vpc_id" {
  description = "Id of VPC"
  value       = aws_vpc.vpc.id
}

output "az_list" {
  description = "Availability Zone List"
  value       = ["ap-northeast-2a", "ap-northeast-2b"]
}

output "subnet_list" {
  description = "Id List of Public Subnet"
  value       = [for subnet in aws_subnet.public-subnet : subnet.id]
}