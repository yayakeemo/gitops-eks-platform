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

data "aws_iam_policy_document" "eks_trust" {
  statement {
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role" "eks_role" {
  name = "gitops-eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_trust.json
}

resource "aws_iam_role_policy_attachment" "eks_cluster"{
  role = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_s3_bucket" "terraform_state"{
  bucket = "gitops-eks-platform-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name = "gitops-terraform-state"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

data "aws_caller_identity" "current" {}

resource "aws_budgets_budget" "gitops" {
  name              = "gitops-monthly-budget"
  budget_type       = "COST"
  limit_amount      = "15"
  limit_unit        = "USD"
  time_unit         = "MONTHLY"
  time_period_start = "2026-11-01_00:00"

  cost_filter {
    name = "Service"
    values = ["EC2", "EKS", "S3", "ECS", "NAT Gateway", "Data Transfer"]
  }

  notification {
    comparison_operator = "GREATER_THAN"
    threshold           = 80
    threshold_type      = "PERCENTAGE"
    notification_type   = "FORECASTED"
    subscriber_email_addresses = ["yahiahussein2001@gmail.com"]
  }

  tags = {
    Name = "gitops-budget"
  }
}

