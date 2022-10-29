provider "aws" {
    region = "eu-central-1"
}



module "subnet" {
    source = "./modules/subnet"
    subnet-cider-block = var.subnet-cider-block
    env-prefix = var.env-prefix
    avail-zone = var.avail-zone
    development-vpc = aws_vpc.development-vpc.id
}
module "ec2-instance" {
    source = "./modules/webserver"
    env-prefix = var.env-prefix
    avail-zone = var.avail-zone
    development-vpc = aws_vpc.development-vpc.id
    my_ip = var.my_ip
    server-key = var.server-key
    image_name = var.image_name
    subnet_id = module.subnet.subnet_output
    my-ec2-type = var.my-ec2-type
}

                                     /****resources****/
resource "aws_vpc" "development-vpc" {
    cidr_block= var.vpc-cider-block
    tags = {
        Name: "${var.env-prefix}-vpc",
        vpc-dev: "dev-part"
    }
}
resource "aws_route_table_association" "development-route-table-association" {
    subnet_id= module.subnet.subnet_output
    route_table_id= module.subnet.rout_table_output
}

# data "aws_vpc" "existing-vpc" {
#   default = true
# }
# resource "aws_subnet" "vpc-default-subnet" {
#     vpc_id = data.aws_vpc.existing-vpc.id
#     cidr_block = "172.31.16.0/20"
#     availability_zone = "eu-central-1a"
#     tags = {
#         Name: "default-subnet-dev"
#     }
# }