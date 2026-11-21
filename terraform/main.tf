terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  
  tags = {
    Name = "gitops-vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"
  
  tags = {
    Name = "gitops-subnet"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "gitops-igw"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
}

  tags = {
    Name = "gitops-route-table"
  }
}

resource "aws_route_table_association" "main" {
  subnet_id = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

resource "aws_ecr_repository" "gitops" {
  name = "gitops-eks-platform"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  
  tags = {
    Name = "gitops-ecr"
  }
  
}

output "repository_url" {
    value = aws_ecr_repository.gitops.repository_url
    description = "The URL of the ECR repository"
}