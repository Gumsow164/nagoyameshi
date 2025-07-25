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
# Subnets
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

#---------------------------------
# Route table
#---------------------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name    = "${var.project}-${var.enviroment}-public_rt"
    Project = var.project
    Env     = var.enviroment
    Type    = "public"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name    = "${var.project}-${var.enviroment}-private_rt"
    Project = var.project
    Env     = var.enviroment
    Type    = "private"
  }
}

resource "aws_route_table_association" "public_rt_1a" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet_1a.id
}

resource "aws_route_table_association" "public_rt_1c" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet_1c.id
}

resource "aws_route_table_association" "private_rt_1a" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.private_subnet_1a.id
}

resource "aws_route_table_association" "private_rt_1c" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.private_subnet_1c.id
}

#---------------------------------
# Internet Gateway
#---------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name    = "${var.project}-${var.enviroment}-igw"
    Project = var.project
    Env     = var.enviroment
    Type    = "private"
  }
}

resource "aws_route" "public_rt_igw_r" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}