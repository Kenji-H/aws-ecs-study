resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Project = var.project_name
  }
}

resource "aws_subnet" "subnet_1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.subnet_1_cidr_block
  availability_zone = var.subnet_1_az
  map_public_ip_on_launch = true
  tags = {
    Project = var.project_name
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.subnet_2_cidr_block
  availability_zone = var.subnet_2_az
  map_public_ip_on_launch = true
  tags = {
    Project = var.project_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Project = var.project_name
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Project = var.project_name
  }
}

resource "aws_route_table_association" "subnet_1_route_table" {
  subnet_id = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "subnet_2_route_table" {
  subnet_id = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.route_table.id
}
