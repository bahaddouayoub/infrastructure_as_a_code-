resource "aws_subnet" "vpc-subnet" {
    vpc_id = var.development-vpc
    cidr_block = var.subnet-cider-block
    availability_zone = var.avail-zone
    tags = {
        Name: "${var.env-prefix}-subnet-1"
    }
}
resource "aws_internet_gateway" "development-internet-gateway" {
    vpc_id= var.development-vpc
    tags = {
        Name: "${var.env-prefix}-igw"
    }
}
resource "aws_route_table" "development-route-table" {
    vpc_id= var.development-vpc
    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.development-internet-gateway.id
    }
    tags = {
        Name: "${var.env-prefix}-rtb"
    }
}