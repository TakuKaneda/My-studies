# public network
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
  # enable name resolution
  enable_dns_support = true
  # allocate dns hostnames automatically
  enable_dns_hostnames = true

  tags = {
    Name = "example"
  }
}

# public subnet
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.0.0/24"
  # allocate public ip address for instances on this subnet
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1a"
}

# internet gateway: connect VPC to internet
resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
}

# route table: routing for internet
# auto create 'local' route
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.example.id
}

# route for internet
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id # table to add
  gateway_id             = aws_internet_gateway.example.id
  destination_cidr_block = "0.0.0.0/0" # default route
}
# associate route table with nw (subnet)
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route.public.id
}

# private network
# create private subnet in VPC
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.64.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false # public ip not required
}

# route table association
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.example.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# NAT gateway: enable access internet from private nw
# EIP (Elastic IP Address): static ip
resource "aws_eip" "nat_gateway" {
  vpc        = true
  depends_on = [aws_internet_gateway.example]
}

# NAT
resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.public.id # location of NAT is placed (not private)
  depends_on    = [aws_internet_gateway.example]
}

# route default to NAT gateway
resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  nat_gateway_id         = aws_nat_gateway.example.id
  destination_cidr_block = "0.0.0.0/0"
}

# security group
# use module
module "example_sg" {
  source      = "./security_group"
  name        = "module-sg"
  vpc_id      = aws_vpc.example.id
  port        = 80            # allow port
  cidr_blocks = ["0.0.0.0/0"] # allow cidr

}
