# Configure the AWS Provider

provider "aws" {
  region = "eu-west-2"
}

# Create a VPC

resource "aws_vpc" "web-app-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "web-app-vpc"
  }
}


# Create Public subnets

resource "aws_subnet" "pub1" {
  cidr_block              = "10.0.0.0/24"
  vpc_id                  = aws_vpc.web-app-vpc.id
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2a"

  tags = {
    Name = "Pub1"
  }
}

resource "aws_subnet" "pub2" {
  cidr_block              = "10.0.1.0/24"
  vpc_id                  = aws_vpc.web-app-vpc.id
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2b"

  tags = {
    Name = "Pub2"
  }
}



# Create Private subnets

resource "aws_subnet" "priv1" {
  cidr_block        = "10.0.2.0/24"
  vpc_id            = aws_vpc.web-app-vpc.id
  availability_zone = "eu-west-2a"

  tags = {
    Name = "Priv1"
  }
}

resource "aws_subnet" "priv2" {
  cidr_block        = "10.0.3.0/24"
  vpc_id            = aws_vpc.web-app-vpc.id
  availability_zone = "eu-west-2b"

  tags = {
    Name = "Priv2"
  }
}

resource "aws_subnet" "priv3" {
  cidr_block        = "10.0.4.0/24"
  vpc_id            = aws_vpc.web-app-vpc.id
  availability_zone = "eu-west-2a"

  tags = {
    Name = "Priv3"
  }
}

resource "aws_subnet" "priv4" {
  cidr_block        = "10.0.5.0/24"
  vpc_id            = aws_vpc.web-app-vpc.id
  availability_zone = "eu-west-2b"

  tags = {
    Name = "Priv4"
  }
}

# Internet Gateway

resource "aws_internet_gateway" "IG" {
  vpc_id = aws_vpc.web-app-vpc.id
}



# Public Route Table

resource "aws_route_table" "Pub-RT" {
  vpc_id = aws_vpc.web-app-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IG.id
  }
}

# CREATE ROUTE TABLE ASSOCIATION

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.pub1.id
  route_table_id = aws_route_table.Pub-RT.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.pub2.id
  route_table_id = aws_route_table.Pub-RT.id
}


# Nat Gateway

resource "aws_eip" "eip" {
}

resource "aws_nat_gateway" "NG" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.pub1.id


  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.IG]
}


# Private Route Tables

resource "aws_route_table" "Priv-RT" {
  vpc_id = aws_vpc.web-app-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NG.id
  }
}


# CREATE ROUTE TABLE ASSOCIATION

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.priv1.id
  route_table_id = aws_route_table.Priv-RT.id
}

resource "aws_route_table_association" "d" {
  subnet_id      = aws_subnet.priv2.id
  route_table_id = aws_route_table.Priv-RT.id
}

resource "aws_route_table_association" "e" {
  subnet_id      = aws_subnet.priv3.id
  route_table_id = aws_route_table.Priv-RT.id
}

resource "aws_route_table_association" "f" {
  subnet_id      = aws_subnet.priv4.id
  route_table_id = aws_route_table.Priv-RT.id
}