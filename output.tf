output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.custom_vpc.id
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.custom_sub.id
}

output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = aws_subnet.private_subnet.id
}

output "public_instance_id" {
  description = "The ID of the public instance"
  value       = aws_instance.my_instance.id
}

output "public_instance_public_ip" {
  description = "The public IP address of the public instance"
  value       = aws_instance.my_instance.public_ip
}

output "private_instance_id" {
  description = "The ID of the private instance"
  value       = aws_instance.my_private_instance.id
}

output "private_instance_private_ip" {
  description = "The private IP address of the private instance"
  value       = aws_instance.my_private_instance.private_ip
}
