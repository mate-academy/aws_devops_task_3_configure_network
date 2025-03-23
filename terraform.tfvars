vpc_id        = "vpc-0026c589fa1509fe4"
subnet_name   = "grafana"
subnet_cidr   = "10.0.1.0/24"
resource_name = "mate-aws-grafana-lab"

allow_trafic = {
  http = {
    from = 80,
    to   = 80,
    cidr = "0.0.0.0/0"
  }
  https = {
    from = 443,
    to   = 443,
    cidr = "0.0.0.0/0"
  }
  ssh = {
    from = 22,
    to   = 22,
    cidr = "176.1.205.248/32"
  }
  grafana = {
    from = 3000,
    to   = 3000,
    cidr = "0.0.0.0/0"
  }
}