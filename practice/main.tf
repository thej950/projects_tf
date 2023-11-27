provider "aws" {
  access_key = var.accessid
  secret_key = var.secretid
  region     = "us-east-1"
}

# added local variable 

locals {
  stage_env = "stageing"
}

# VPC creation "myvpc"

resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${local.stage_env}-thej-vpc"
  }
}

# Internetgateway creation 

resource "aws_internet_gateway" "myitgw" {
  vpc_id = aws_vpc.myvpc.id
}

# subnet creation inside myvpc

resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "${local.stage_env}-thej-public-subnet"
  }
}

# route table creation with route-table1

resource "aws_route_table" "route-table1" {
  vpc_id = aws_vpc.myvpc.id
}

# Route route-table1 to itgw

resource "aws_route" "route_to_itgw" {
  route_table_id         = aws_route_table.route-table1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.myitgw.id
}

# association of route-table1 to public-subnet

resource "aws_route_table_association" "public-subnet-association" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.route-table1.id
}

# Launch instance in public-subnet 

resource "aws_instance" "myec2" {
  ami                         = var.amiid
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public-subnet.id
  associate_public_ip_address = true
  tags = {
    Name = "${local.stage_env}-thej-webserver"
  }
}

