##################
# VPC
##################
resource "aws_vpc" "this" {
  count = var.create_vpc ? 1 : 0

  cidr_block                       = var.vpc_cidr
  enable_dns_support               = var.enable_dns_support
  enable_dns_hostnames             = var.enable_dns_hostnames
  assign_generated_ipv6_cidr_block = var.enable_ipv6

  tags = merge(
    {
      "Name" = format("%s", var.name),
    },
    var.tags,
    var.vpc_tags
  )
}

##################
# Internet Gateway
##################
resource "aws_internet_gateway" "this" {
  count = var.create_vpc && var.create_igw && length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.this[count.index].id

  tags = merge(
    {
      "Name" = format("%s", var.name),
    },
    var.tags,
    var.vpc_tags
  )
}

##################
# Private Subnets
##################
resource "aws_subnet" "private" {
  count = var.create_vpc && length(var.private_subnets) > 0 && length(var.private_subnets) >= length(var.azs) ? length(var.private_subnets) : 0

  vpc_id            = aws_vpc.this[0].id
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.azs, count.index)

  tags = merge(
    {
      "Name" = format("%s-${var.private_subnet_suffix}-%s", var.name, element(var.azs, count.index))
    },
    var.tags,
    var.public_subnet_tags
  )
}

##################
# Public Subnets
##################
resource "aws_subnet" "public" {
  count = var.create_vpc && length(var.public_subnets) > 0 && length(var.public_subnets) >= length(var.azs) ? length(var.public_subnets) : 0

  vpc_id                  = aws_vpc.this[0].id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = var.enable_map_public_ip_launch

  tags = merge(
    {
      "Name" = format("%s-${var.public_subnet_suffix}-%s", var.name, element(var.azs, count.index))
    },
    var.tags,
    var.private_subnet_tags
  )
}

##################
# NAT Gateway
##################
resource "aws_eip" "nat" {
  count = var.create_vpc && var.single_nat_gateway ? 1 : 0

  vpc = true

  tags = merge(
    {
      "Name" = format("%s-%s", var.name, var.single_nat_gateway)
    },
    var.tags,
    var.nat_eip_tags
  )
}

resource "aws_nat_gateway" "this" {
  count = var.create_vpc && var.single_nat_gateway ? 1 : 0

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    {
      "Name" = format("%s-%s", var.name, element(var.azs, count.index))
    },
    var.tags,
    var.nat_gateway_tags
  )
}

########################
# Route table for public subnets
########################
resource "aws_route_table" "public" {
  count = var.create_vpc && var.create_igw && length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.this[count.index].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[count.index].id
  }

  tags = merge(
    {
      "Name" = format("%s-%s", var.name, var.public_subnet_suffix)
    },
    var.tags,
    var.public_route_table_tags
  )
}

resource "aws_route_table_association" "public" {
  count = var.create_vpc && var.create_igw && length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[0].id
}

########################
# Route table for private subnets
########################
resource "aws_route_table" "private" {
  count = var.create_vpc && var.single_nat_gateway && length(var.private_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.this[count.index].id

  dynamic route {
    for_each = var.nat_destinations
    content {
      cidr_block     = route.value
      nat_gateway_id = aws_nat_gateway.this[count.index].id
    }
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[count.index].id
  }

  tags = merge(
    {
      "Name" = format("%s-%s", var.name, var.private_subnet_suffix)
    },
    var.tags,
    var.private_route_table_tags
  )
}

resource "aws_route_table_association" "private" {
  count = var.create_vpc && var.create_igw && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[0].id
}

########################
# S3 VPC Endpoint
########################
resource "aws_vpc_endpoint" "s3" {
  count = var.create_vpc && var.enable_s3_endpoint ? 1 : 0

  vpc_id       = aws_vpc.this[count.index].id
  service_name = var.s3_vpc_endpoint != null ? var.s3_vpc_endpoint : "com.amazonaws.${var.aws_region}.s3"

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
    var.vpc_tags
  )
}

########################
# S3 VPC Endpoint Public Subnet Association
########################
resource "aws_vpc_endpoint_route_table_association" "s3_public" {
  count = var.create_vpc && var.enable_s3_endpoint ? 1 : 0
  #  for_each = toset(aws_route_table.public.*.id)
  route_table_id  = aws_route_table.public[0].id
  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
}

########################
# S3 VPC Endpoint Private Subnet Association
########################
resource "aws_vpc_endpoint_route_table_association" "s3_private" {
  count = var.create_vpc && var.enable_s3_endpoint ? 1 : 0
  #for_each = toset(aws_route_table.private.*.id)
  #route_table_id = each.key
  route_table_id  = aws_route_table.public[0].id
  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
}
