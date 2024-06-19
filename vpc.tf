resource "aws_vpc" "custom_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "custom_vpc"
  }
}

resource "aws_subnet" "custom_sub" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-south-1a"
  tags = {
    Name = "public_sub"
  }
}

resource "aws_internet_gateway" "custom_ig" {
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
    Name = "public_tg"
  }
}

resource "aws_route_table" "custom_rt" {
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
    Name = "public_rt"
  }
}

resource "aws_route" "my_route" {
  route_table_id         = aws_route_table.custom_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.custom_ig.id
}

resource "aws_route_table_association" "my_route_table_association" {
  subnet_id      = aws_subnet.custom_sub.id
  route_table_id = aws_route_table.custom_rt.id
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "my_private_subnet"
  }
}

resource "aws_route_table" "custom_private_rt" {
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
    Name = "private_rt"
  }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "private_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.custom_sub.id
  tags = {
    Name = "my_nat_gateway"
  }
}

resource "aws_route" "my_private_route" {
  route_table_id         = aws_route_table.custom_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.private_gateway.id
}

resource "aws_route_table_association" "my_private_route_table_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.custom_private_rt.id
}
