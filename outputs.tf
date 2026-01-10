output "subnet_id" {
  description = "ID of the VPC subnet, deployed by the module"
  value       = aws_subnet.grafana.id
}

output "security_group_id" {
  description = "ID of the security group, deployed by the module"
  value       = aws_security_group.grafana.id
}

output "route_table_id" {
  value = aws_route_table.grafana.id
}

output "igw_id" {
  value = aws_internet_gateway.grafana.id
}
