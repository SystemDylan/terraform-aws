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
  propagating_vgws = [aws_vpn_gateway.vpc1_vgw.id] #propogate routes from vpn gateway
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

# Create VPN gateway for ipsec VPN tunnel
resource "aws_vpn_gateway" "vpc1_vgw" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "vpc1_vgw"
  }
}

# Create Customer Gateway for ipsec VPN tunnel connection
resource "aws_customer_gateway" "vpc1_cg" {
  bgp_asn    = 65000
  ip_address = var.publicip
  type       = "ipsec.1"
  tags = {
    Name = "vpc1_cg"
  }
}

# Create VPN connection between the Virtual Private Gateway and the Customer Gateway
resource "aws_vpn_connection" "vpc1_vpn_connection" {
  vpn_gateway_id      = aws_vpn_gateway.vpc1_vgw.id
  customer_gateway_id = aws_customer_gateway.vpc1_cg.id
  type                = "ipsec.1"
  static_routes_only  = true
}

# Create static route for VPN connection to local subnet
resource "aws_vpn_connection_route" "vpc1_vpn_connection_route" {
  destination_cidr_block = "${var.localsubnet}/24"
  vpn_connection_id      = aws_vpn_connection.vpc1_vpn_connection.id
}

# Output the public IP of the AWS VPN connection
output "aws_vpn_connection_public_ip" {
  value = aws_vpn_connection.vpc1_vpn_connection.tunnel1_address
}
