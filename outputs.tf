    
output "aws-public-ip" {
  value       = module.ec2-instance.ec2-instance-output
}

output "id-vpc" {
  description = "ID of the vpc instance"
  value       = aws_vpc.development-vpc.id
}

output "id-subnet" {
  description = "subnet instance"
  value       = module.subnet.subnet_output
}