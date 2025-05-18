output "grafana_subnet_id" {
  value = aws_subnet.grafana.id
}

output "grafana_igw_id" {
  value = aws_internet_gateway.grafana_igw.id
}

output "grafana_route_table_id" {
  value = aws_route_table.grafana_rt.id
}

output "grafana_sg_id" {
  value = aws_security_group.grafana_sg.id
}
