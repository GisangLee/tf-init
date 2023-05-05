variable "ENV" {}
variable "AWS_REGION" {}

// VPC
resource "aws_vpc" "toktokhan-test-vpc" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    IaC = "Terraform"
    ENV = "${var.ENV}"
    Name = "toktokhan-test-${var.ENV}-vpc"
  }
}


// Internet Gateway
resource "aws_internet_gateway" "toktokhan-test-igw" {
  vpc_id = aws_vpc.toktokhan-test-vpc.id

  tags = {
    Iac = "Terraform"
    ENV = var.ENV
    Name = "toktokhan-test-${var.ENV}-igw"
  }
}


# NAT Gateway EIP
resource "aws_eip" "toktokhan-test-ngw-eip" {
  vpc = true

  depends_on = [aws_internet_gateway.toktokhan-test-igw]

  tags = {
    Iac = "Terraform"
    ENV = var.ENV
    Name = "toktokhan-test-${var.ENV}-ngw-eip"
  }
}


# NAT Gateway
resource "aws_nat_gateway" "toktokhan-test-ngw" {
  allocation_id = aws_eip.toktokhan-test-ngw-eip.id
  subnet_id     = aws_subnet.toktokhan-test-public-subnet[0].id
  depends_on    = [aws_subnet.toktokhan-test-public-subnet[0]]
  tags = {
    IaC = "Terraform"
    ENV = var.ENV
    Name = "toktokhan-test-${var.ENV}-ngw"
  }


}

# Public Routing Table
resource "aws_route_table" "toktokhan-test-public-rt" {
  vpc_id = aws_vpc.toktokhan-test-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.toktokhan-test-igw.id
  }

  tags = {
    IaC = "Terraform"
    ENV = var.ENV
    Name = "toktokhan-test-${var.ENV}-public-rt"
  }
}

# Private Routing Table
resource "aws_route_table" "toktokhan-test-private-rt" {
  vpc_id = aws_vpc.toktokhan-test-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.toktokhan-test-ngw.id
  }

  tags = {
    IaC = "Terraform"
    ENV = var.ENV
    Name = "toktokhan-test-${var.ENV}-private-rt"
  }
}


# Public Subnet
resource "aws_subnet" "toktokhan-test-public-subnet" {
  count = 2
  vpc_id = aws_vpc.toktokhan-test-vpc.id
  availability_zone = "ap-northeast-2${count.index + 1 == 1 ? "a" : "b"}"
  cidr_block = "10.0.${count.index + 1}.0/24"

  tags = {
    Iac = "Terraform"
    ENV = var.ENV
    Name = "toktokhan-test-${var.ENV}-public-subnet"
  }
}

# Private Subnet
resource "aws_subnet" "toktokhan-test-private-subnet" {
  count             = 2
  vpc_id            = aws_vpc.toktokhan-test-vpc.id
  availability_zone = "ap-northeast-2${count.index + 1 == 1 ? "a" : "b"}"
  cidr_block        = "10.0.${count.index + 3}.0/24"

  tags = {
    Iac = "Terraform"
    ENV = var.ENV
    Name = "toktokhan-test-${var.ENV}-public-subnet"
  }
}

# Public Subnet < - > Routing Table
resource "aws_route_table_association" "toktokhan-test-public-subnet-association" {
  count          = 2
  subnet_id      = aws_subnet.toktokhan-test-public-subnet[count.index].id
  route_table_id = aws_route_table.toktokhan-test-public-rt.id

  depends_on = [ aws_subnet.toktokhan-test-public-subnet ]
}


# Private Subnet < - > Routing Table
resource "aws_route_table_association" "toktokhan-test-private-subnet-association" {
  count          = 2
  subnet_id      = aws_subnet.toktokhan-test-private-subnet[count.index].id
  route_table_id = aws_route_table.toktokhan-test-private-rt.id
  depends_on     = [aws_subnet.toktokhan-test-private-subnet]
  
}
