terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# 🚀 VPC
resource "aws_vpc" "free_tier_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "aws-VPC"
  }
}

# 🚀 Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.free_tier_vpc.id

  tags = {
    Name = "aws-IGW"
  }
}

# 🚀 Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.free_tier_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "aws-Public-Subnet"
  }
}

# 🚀 Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.free_tier_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "aws-Public-RouteTable"
  }
}

# 🚀 Associate Route Table with Public Subnet
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# 🚀 Security Group (allow SSH & HTTP)
resource "aws_security_group" "instance_sg" {
  name        = "aws-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.free_tier_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "aws-SG"
  }
}

# 🚀 EC2 Instance (Free Tier eligible)
resource "aws_instance" "free_tier_ec2" {
  ami                    = "ami-02a53b0d62d37a757" # Amazon Linux 2 AMI
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  key_name               = "demo3" # Replace with your EC2 key pair name

  tags = {
    Name = "aws-EC2"
  }
}
