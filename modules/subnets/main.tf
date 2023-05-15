# Datasource for AZs
data "aws_availability_zones" "available" {
  state = var.subnets_az_state_filter
}

#################################################
# Public Subnet(s)
#################################################
resource "aws_subnet" "public_subnets" {
  count = var.subnets_public_count
  vpc_id = var.subnets_target_vpc_id
  cidr_block = element(var.subnets_public_cidrs, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
 
  tags = merge(var.subnets_tags, { Name = "terraform-public-subnet-${count.index + 1}"})
}

#################################################
# Private Subnets
#################################################
resource "aws_subnet" "private_subnets" {
  count = var.subnets_private_count
  vpc_id = var.subnets_target_vpc_id
  cidr_block = element(var.subnets_private_cidrs, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
 
  tags = merge(var.subnets_tags, { Name = "terraform-private-subnet-${count.index + 1}"})
}

#################################################
# NAT Gateway Elastic IP
#################################################
resource "aws_eip" "nat_gateway_eip" {
  vpc = true
}

#################################################
# Main NAT Gateway
#################################################
resource "aws_nat_gateway" "main" {
  count = var.subnets_enable_nat_gateway == true ? 1 : 0
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id = aws_subnet.public_subnets[0].id

  tags = { Name = "terraform-nat-gateway"}
}

#################################################
# Public Subnet Route Table
#################################################
resource "aws_route_table" "public_subnet_rt" {
  vpc_id = var.subnets_target_vpc_id
 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.subnets_target_vpc_igw_id
  }
 
  tags = { Name = "terraform-public-route-table"}
}

#################################################
# Private Subnets Route Table
#################################################
resource "aws_route_table" "private_subnet_rt" {
  vpc_id = var.subnets_target_vpc_id
 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.main[0].id
  }
 
  tags = { Name = "terraform-private-route-table"}
}

#################################################
# Public Route Table Association
#################################################
resource "aws_route_table_association" "public_rt_assocs" {
  count = var.subnets_public_count
  subnet_id = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public_subnet_rt.id
}

#################################################
# Private Route Table Association
#################################################
resource "aws_route_table_association" "private_rt_assocs" {
  count = var.subnets_enable_nat_gateway == true ? var.subnets_private_count : 0
  subnet_id = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = aws_route_table.private_subnet_rt.id
}