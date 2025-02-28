resource "aws_vpc" "luan-vpc-eks-test" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = merge(
    var.tag,
    {
      Name = var.vpc_name
    }
  )
}

resource "aws_subnet" "luan-sn-public-01" {
  vpc_id                  = aws_vpc.luan-vpc-eks-test.id
  cidr_block              = var.sn_public_01_cidr_block
  map_public_ip_on_launch = var.public_ip_on_launch
  availability_zone       = var.az_public_01
  tags = merge(
    var.tag,
    {
      Name = "luan-sn-public-01"
    }
  )
}

resource "aws_subnet" "luan-sn-public-02" {
  vpc_id                  = aws_vpc.luan-vpc-eks-test.id
  cidr_block              = var.sn_public_02_cidr_block
  map_public_ip_on_launch = var.public_ip_on_launch
  availability_zone       = var.az_public_02
  tags = merge(
    var.tag,
    {
      Name = "luan-sn-public-02"
    }
  )
}

resource "aws_subnet" "luan-sn-private-01" {
  vpc_id            = aws_vpc.luan-vpc-eks-test.id
  cidr_block        = var.sn_private_01_cidr_block
  availability_zone = var.az_private_01
  tags = merge(
    var.tag,
    {
      Name = "luan-sn-private-01"
    }
  )
}

resource "aws_subnet" "luan-sn-private-02" {
  vpc_id            = aws_vpc.luan-vpc-eks-test.id
  cidr_block        = var.sn_private_02_cidr_block
  availability_zone = var.az_private_02
  tags = merge(
    var.tag,
    {
      Name = "luan-sn-private-02"
    }
  )
}

# IGW
resource "aws_internet_gateway" "luan-igw-01" {
  vpc_id = aws_vpc.luan-vpc-eks-test.id
  tags   = var.tag
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat_gateway_eip" {
  domain = "vpc"
  tags = merge(
    var.tag,
    {
      Name = "luan-nat-gateway-eip"
    }
  )
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = aws_subnet.luan-sn-public-01.id # Public Subnet for NAT Gateway
  depends_on    = [aws_internet_gateway.luan-igw-01]
  tags = merge(
    var.tag,
    {
      Name = "luan-nat-gateway"
    }
  )
}

# Route for Private Subnets to use NAT Gateway
resource "aws_route" "luan-rtb-private" {
  route_table_id         = aws_route_table.luan-rtb-private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
  depends_on             = [aws_nat_gateway.nat_gateway]
}

# Route table public
resource "aws_route_table" "luan-rtb-public" {
  vpc_id = aws_vpc.luan-vpc-eks-test.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.luan-igw-01.id
  }
  tags = merge(
    var.tag,
    {
      Name = "luan-rtb-public-01"
    }
  )
}

# Public association 1
resource "aws_route_table_association" "luan-public-association-01" {
  subnet_id      = aws_subnet.luan-sn-public-01.id
  route_table_id = aws_route_table.luan-rtb-public.id
}
# Public association 2
resource "aws_route_table_association" "luan-public-association-02" {
  subnet_id      = aws_subnet.luan-sn-public-02.id
  route_table_id = aws_route_table.luan-rtb-public.id
}

# Route table private
resource "aws_route_table" "luan-rtb-private" {
  vpc_id = aws_vpc.luan-vpc-eks-test.id
  tags = merge(
    var.tag,
    {
      Name = "luan-rtb-private-01"
    }
  )
}

resource "aws_route_table_association" "luan-private-association-01" {
  subnet_id      = aws_subnet.luan-sn-private-01.id
  route_table_id = aws_route_table.luan-rtb-private.id
}
resource "aws_route_table_association" "luan-private-association-02" {
  subnet_id      = aws_subnet.luan-sn-private-02.id
  route_table_id = aws_route_table.luan-rtb-private.id
}

resource "aws_security_group" "eks_security_group" {
  name        = "luan-eks-cluster-sg"
  description = "EKS cluster communication security group"
  vpc_id      = aws_vpc.luan-vpc-eks-test.id
  tags        = var.tag

  # Ingress Rules (Allow inbound traffic)
  ingress {
    description = "Allow all traffic from worker nodes"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true # Allow communication within the EKS cluster
  }

  ingress {
    description = "Allow HTTPS from the Internet for API server"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  # Egress Rules (Allow outbound traffic)
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

