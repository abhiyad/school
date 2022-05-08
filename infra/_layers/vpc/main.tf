terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.73.0"
    }
  }
  backend "s3" {

  }
}

provider "aws" {
  region = var.region
  allowed_account_ids = [var.aws_account_id]
}

resource "aws_vpc" "ayadav_test_vpc" {
  cidr_block = var.cidr
  tags = {
    Name = "ayadav-test-vpc"
  }
}
 
resource "aws_internet_gateway" "ayadav_internet_gateway" {
  vpc_id = aws_vpc.ayadav_test_vpc.id
  tags = {
    Name = "internet-gateway-ayadav-vpc"
  }
}

resource "aws_subnet" "ayadav_private_subent_a" {
  vpc_id     = aws_vpc.ayadav_test_vpc.id
  cidr_block = var.private_subnet_cidr_a
  availability_zone = "us-east-2a"
  tags = {
    Name = "priavte-subnet-a-ayadav"
  }
}

resource "aws_subnet" "ayadav_public_subent_a" {
  vpc_id     = aws_vpc.ayadav_test_vpc.id
  cidr_block = var.public_subnet_cidr_a
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-a-ayadav"
  }
}

resource "aws_subnet" "ayadav_private_subent_b" {
  vpc_id     = aws_vpc.ayadav_test_vpc.id
  cidr_block = var.private_subnet_cidr_b
  availability_zone = "us-east-2b"
  tags = {
    Name = "priavte-subnet-b-ayadav"
  }
}

resource "aws_subnet" "ayadav_public_subent_b" {
  vpc_id     = aws_vpc.ayadav_test_vpc.id
  cidr_block = var.public_subnet_cidr_b
  availability_zone = "us-east-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-b-ayadav"
  }
}

// create 2 route tables
// 1 for public,1 for private
// add rule for 0.0.0.0/0 to internet gateway in the public route table

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.ayadav_test_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ayadav_internet_gateway.id
  }
  tags = {
    Name = "public-rt-ayadav"
  }
}


resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.ayadav_test_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ayadav_nat_gateway.id
  }
  tags = {
    Name = "private-rt-ayadav"
  }
}

// associate public rt to public subnet, private rt to private subnet

// create a nat gw


resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "ayadav_nat_gateway" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.ayadav_private_subent_a.id

  tags = {
    Name = "ayadav-vpc nat gw"
  }

  depends_on = [aws_internet_gateway.ayadav_internet_gateway]
}

//

resource "aws_route_table_association" "public-rt-association-a" {
  subnet_id      = aws_subnet.ayadav_public_subent_a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public-rt-association-b" {
  subnet_id      = aws_subnet.ayadav_public_subent_b.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private-rt-association-a" {
  subnet_id      = aws_subnet.ayadav_private_subent_a.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private-rt-association-b" {
  subnet_id      = aws_subnet.ayadav_private_subent_b.id
  route_table_id = aws_route_table.private_route_table.id
}

// 