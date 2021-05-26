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
# resource "aws_subnet" "public" {
#   vpc_id     = aws_vpc.example.id
#   cidr_block = "10.0.0.0/24"
#   # allocate public ip address for instances on this subnet
#   map_public_ip_on_launch = true
#   availability_zone       = "ap-northeast-1a"
# }
resource "aws_subnet" "public_0" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true
}

# internet gateway: connect VPC to internet
resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
}

# route table: routing for internet
# auto create 'local' route
# resource "aws_route_table" "public" {
#   vpc_id = aws_vpc.example.id
# }
resource "aws_route_table_association" "public_0" {
  subnet_id      = aws_subnet.public_0.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
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
# resource "aws_subnet" "private" {
#   vpc_id                  = aws_vpc.example.id
#   cidr_block              = "10.0.64.0/24"
#   availability_zone       = "ap-northeast-1a"
#   map_public_ip_on_launch = false # public ip not required
# }
resource "aws_subnet" "private_0" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.65.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
}

resource "aws_subnet" "private_1" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.66.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false
}

# NAT gateway: enable access internet from private nw
# EIP (Elastic IP Address): static ip
# resource "aws_eip" "nat_gateway" {
#   vpc        = true
#   depends_on = [aws_internet_gateway.example]
# }
# # NAT
# resource "aws_nat_gateway" "example" {
#   allocation_id = aws_eip.nat_gateway.id
#   subnet_id     = aws_subnet.public.id # location of NAT is placed (not private)
#   depends_on    = [aws_internet_gateway.example]
# }
resource "aws_eip" "nat_gateway_0" {
  vpc        = true
  depends_on = [aws_internet_gateway.example]
}

resource "aws_eip" "nat_gateway_1" {
  vpc        = true
  depends_on = [aws_internet_gateway.example]
}

resource "aws_nat_gateway" "nat_gateway_0" {
  allocation_id = aws_eip.nat_gateway_0.id
  subnet_id     = aws_subnet.public_0.id
  depends_on    = [aws_internet_gateway.example]
}

resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.nat_gateway_1.id
  subnet_id     = aws_subnet.public_1.id
  depends_on    = [aws_internet_gateway.example]
}

# # route table association
# resource "aws_route_table" "private" {
#   vpc_id = aws_vpc.example.id
# }

# resource "aws_route_table_association" "private" {
#   subnet_id      = aws_subnet.private.id
#   route_table_id = aws_route_table.private.id
# }
# # route default to NAT gateway
# resource "aws_route" "private" {
#   route_table_id         = aws_route_table.private.id
#   nat_gateway_id         = aws_nat_gateway.example.id
#   destination_cidr_block = "0.0.0.0/0"
# }
resource "aws_route_table" "private_0" {
  vpc_id = aws_vpc.example.id
}

resource "aws_route_table" "private_1" {
  vpc_id = aws_vpc.example.id
}

resource "aws_route" "private_0" {
  route_table_id         = aws_route_table.private_0.id
  nat_gateway_id         = aws_nat_gateway.nat_gateway_0.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "private_1" {
  route_table_id         = aws_route_table.private_1.id
  nat_gateway_id         = aws_nat_gateway.nat_gateway_1.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "private_0" {
  subnet_id      = aws_subnet.private_0.id
  route_table_id = aws_route_table.private_0.id
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_1.id
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
