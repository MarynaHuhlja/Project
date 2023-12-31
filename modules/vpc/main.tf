
####Create VPC and IGW ####
data "aws_availability_zones" "available" {
   state = "available"
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.env}-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id ##attaching to VPC "main"
  tags = {
    Name = "${var.env}-igw"
  }

}
#### Public Subnet and Routing ####
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs) #  поскольку в var.public_subnet_cidrs пррписани 2 сабнета, то создаст 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)            #берет єлемент сайдер блоков 
  availability_zone       = data.aws_availability_zones.available.names[count.index] # проверяет
  map_public_ip_on_launch = true                                                     #делает чтоб получали public IP 
  tags = {
    Name = "${var.env}-public-${count.index + 1}"
  }
}
resource "aws_route_table" "public_subnets" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "${var.env}-route-public-subnets"
  }
}

#### Associate route-table with all subnets ####
resource "aws_route_table_association" "public_routes" {
  count          = length(aws_subnet.public_subnets[*].id)
  route_table_id = aws_route_table.public_subnets.id
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
}

##### NAT Gateway with Elastic IPs####
resource "aws_eip" "nat" {
  count = length(var.private_subnet_cidrs)
  tags = {
    Name = "${var.env}-nat-gw-${count.index + 1}"
  }
}

resource "aws_nat_gateway" "nat" {
  count         = length(var.private_subnet_cidrs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = element(aws_subnet.public_subnets[*].id, count.index)
  tags = {
    Name = "${var.env}-nat-gw-${count.index + 1}"
  }

}
#### Private Subnets and Routing ####
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs) #  поскольку в var.public_subnet_cidrs пррписани 2 сабнета, то создаст 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)           #берет єлемент сайдер блоков 
  availability_zone = data.aws_availability_zones.available.names[count.index] # проверяет
  tags = {
    Name = "${var.env}-private-${count.index + 1}"
  }
}

resource "aws_route_table" "private_subnets" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat[count.index].id
  }
  tags = {
    Name = "${var.env}-route-private-subnet-${count.index + 1}"
  }
}

resource "aws_route_table_association" "private_routes" {
  count          = length(aws_subnet.private_subnets[*].id)
  route_table_id = aws_route_table.private_subnets[count.index].id
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
}
