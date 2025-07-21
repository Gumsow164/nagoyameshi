#---------------------------------
# VPC
#---------------------------------

resource "aws_vpc" "dev_vpc" {
  cidr_block                       = var.vpc_cidr
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name    = "${var.project}-${var.enviroment}-vpc"
    Project = var.project
    Env     = var.enviroment

  }
}

#---------------------------------
# Public Subnets
#---------------------------------
resource "aws_subnet" "public_subnet_1a" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = var.public_subnet_cidrs[0]
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name    = "${var.project}-${var.enviroment}-public_subnet_1a"
    Project = var.project
    Env     = var.enviroment
    Type    = "public"
  }
}

resource "aws_subnet" "public_subnet_1c" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = var.public_subnet_cidrs[1]
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true
  tags = {
    Name    = "${var.project}-${var.enviroment}-public_subnet_1c"
    Project = var.project
    Env     = var.enviroment
    Type    = "public"
  }
}

resource "aws_subnet" "private_subnet_1a" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = var.private_subnet_cidrs[0]
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name    = "${var.project}-${var.enviroment}-private_subnet_1a"
    Project = var.project
    Env     = var.enviroment
    Type    = "private"
  }
}

resource "aws_subnet" "private_subnet_1c" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = var.private_subnet_cidrs[1]
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true
  tags = {
    Name    = "${var.project}-${var.enviroment}-private_subnet_1c"
    Project = var.project
    Env     = var.enviroment
    Type    = "private"
  }
}

