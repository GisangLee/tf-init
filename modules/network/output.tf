output "vpc_id" {
  description = "Id of VPC"
  value = aws_vpc.toktokhan-test-vpc.id
}

output "az_list" {
  description = "Availability Zone List"
  value = ["ap-northeast-2a", "ap-northeast-2b"]
}

output "subnet_list" {
  description = "Id List of Public Subnet"
  value = [for subnet in aws_subnet.toktokhan-test-public-subnet : subnet.id]
}