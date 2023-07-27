# VPC, Subnets, Route table, RT associations



resource "aws_vpc" "EC2VPC" {
  cidr_block           = "172.31.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = false
  instance_tenancy     = "default"
  tags = {
    Name = "cloudformation"
  }
}

resource "aws_subnet" "EC2Subnet1" {
  availability_zone       = "us-east-1b"
  cidr_block              = "172.31.1.0/24"
  vpc_id                  = aws_vpc.EC2VPC.id
  map_public_ip_on_launch = false
}

resource "aws_subnet" "EC2Subnet2" {
  availability_zone       = "us-east-1a"
  cidr_block              = "172.31.0.0/24"
  vpc_id                  = aws_vpc.EC2VPC.id
  map_public_ip_on_launch = false
}

resource "aws_route_table" "EC2RouteTable" {
  vpc_id = aws_vpc.EC2VPC.id
  tags   = {}
}


resource "aws_vpc_endpoint" "EC2VPCEndpoint" {
  vpc_endpoint_type = "Gateway"
  vpc_id            = aws_vpc.EC2VPC.id
  service_name      = "com.amazonaws.us-east-1.s3"
  policy            = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":\"*\",\"Action\":[\"s3:Get*\",\"s3:PutObject\",\"s3:List*\"],\"Resource\":\"*\"}]}"
  route_table_ids = [
    aws_route_table.EC2RouteTable.id
  ]
  private_dns_enabled = false
}

resource "aws_route_table_association" "EC2SubnetRouteTableAssociation" {
  route_table_id = aws_route_table.EC2RouteTable.id
  subnet_id      = aws_subnet.EC2Subnet1.id
}

resource "aws_route_table_association" "EC2SubnetRouteTableAssociation2" {
  route_table_id = aws_route_table.EC2RouteTable.id
  subnet_id      = aws_subnet.EC2Subnet2.id
}
