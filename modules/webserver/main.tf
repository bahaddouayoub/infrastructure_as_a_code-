resource "aws_security_group" "development-security-group" {
    vpc_id= var.development-vpc
    name = "my-security_group"
    ingress {
        from_port= 22
        to_port= 22
        protocol= "tcp"
        cidr_blocks= [var.my_ip]
    }
    ingress {
        from_port= 8080
        to_port= 8080
        protocol= "tcp"
        cidr_blocks= [var.my_ip]
    }
    egress {
        from_port= 0
        to_port= 0
        protocol= "-1"
        cidr_blocks= ["0.0.0.0/0"]
    }

    tags = {
        Name: "${var.env-prefix}-sg"
    }
}
resource "aws_key_pair" "server-key" {
    key_name = "server_key"
    public_key = "${file(var.server-key)}"
}
data "aws_ami" "development-ami"{
    most_recent = true
    owners = ["amazon"]
    filter { 
    name = "name"
    values = [var.image_name]
    }
    # filter { 
    # name = "virtualization_type"
    # values = ["hvm"]
    # }
}
resource "aws_instance" "development-ec2-instance"{
    ami=data.aws_ami.development-ami.id
    instance_type = var.my-ec2-type
    subnet_id = var.subnet_id
    vpc_security_group_ids = [ aws_security_group.development-security-group.id ]
    associate_public_ip_address = true
    availability_zone = var.avail-zone
    key_name = aws_key_pair.server-key.key_name
    user_data = file("entry-point.sh")
    tags = {
        Name: "${var.env-prefix}-server"
    }

}
