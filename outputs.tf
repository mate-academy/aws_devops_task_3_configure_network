output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.web_sg.id
}

output "public_subnet_id" {
  description = "ID of the public subnet" 
  value       = aws_subnet.public.id
}