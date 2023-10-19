# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.prefix}vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.prefix}igw"
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  count = length(var.azs)
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.${count.index}.0/24"
  availability_zone = var.azs[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.prefix}public-subnet-${count.index}"
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  count = length(var.azs)
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.${count.index + 10}.0/24"
  availability_zone = var.azs[count.index]
  tags = {
    Name = "${var.prefix}private-subnet-${count.index}"
  }
}

# Default NACL (Allows all traffic)
resource "aws_network_acl" "default" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.prefix}default-nacl"
  }
}

# NACL for Public Subnets (Allows HTTP, HTTPS, SSH, etc.)
resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.main.id

  egress {
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
  }

  ingress {
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
  }

  tags = {
    Name = "${var.prefix}public-nacl"
  }
}

resource "aws_network_acl_association" "public" {
  count          = length(var.azs)
  subnet_id      = aws_subnet.public[count.index].id
  network_acl_id = aws_network_acl.public.id
}

# NACL for Private Subnets (Allows specific internal traffic)
resource "aws_network_acl" "private" {
  vpc_id = aws_vpc.main.id

  egress {
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
  }

  ingress {
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.main.cidr_block
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
  }

  ingress {
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
    protocol   = "tcp"
  }

  tags = {
    Name = "${var.prefix}private-nacl"
  }
}

resource "aws_network_acl_association" "private" {
  count          = length(var.azs)
  subnet_id      = aws_subnet.private[count.index].id
  network_acl_id = aws_network_acl.private.id
}

# NAT Gateway for Private Subnets
resource "aws_eip" "nat" {
  count  = length(var.azs)
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  count         = length(var.azs)
  subnet_id     = aws_subnet.public[count.index].id
  allocation_id = aws_eip.nat[count.index].id
  tags = {
    Name = "${var.prefix}nat-gateway-${count.index}"
  }
}

# Route tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.prefix}public-route-table"
  }
}

resource "aws_route_table" "private" {
  count  = length(var.azs)
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }
  tags = {
    Name = "${var.prefix}private-route-table-${count.index}"
  }
}

# Associate subnets with route tables
resource "aws_route_table_association" "public" {
  count          = length(var.azs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.azs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
