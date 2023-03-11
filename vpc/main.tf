# Create a new VPC with the a primary CIDR block
resource "aws_vpc" "vpc1" {
  cidr_block = var.main_block
  tags = {
    Name = "vpc1"
  }
}

# Create a new internet gateway and attach it to the VPC
resource "aws_internet_gateway" "vpc1_igw" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "vpc1_igw"
  }
}

# Create a new route table and associate it with the VPC and internet gateway
resource "aws_route_table" "vpc1_route_table" {
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc1_igw.id
  }
  tags = {
    Name = "vpc1_route_table"
  }
}

# Create a new subnet in the VPC with a specific CIDR block and availability zone
resource "aws_subnet" "vpc1_subnet1" {
  vpc_id = aws_vpc.vpc1.id
  cidr_block = var.subnet1
  availability_zone = var.region1
  map_public_ip_on_launch = true
  tags = {
    Name = "vpc1_subnet1"
  }
}

# Create a second new subnet in the VPC with a different CIDR block and a different availability zone
resource "aws_subnet" "vpc1_subnet2" {
  vpc_id = aws_vpc.vpc1.id
  cidr_block = var.subnet2
  availability_zone = var.region2
  map_public_ip_on_launch = true
  tags = {
    Name = "vpc1_subnet2"
  }
}

# Associate the first subnet with the new route table
resource "aws_route_table_association" "vpc1_route_table_association" {
  subnet_id = aws_subnet.vpc1_subnet1.id
  route_table_id = aws_route_table.vpc1_route_table.id
}

# Associate the second subnet with the same route table as the first subnet
resource "aws_route_table_association" "vpc1_route_table_association2" {
  subnet_id = aws_subnet.vpc1_subnet2.id
  route_table_id = aws_route_table.vpc1_route_table.id
}
