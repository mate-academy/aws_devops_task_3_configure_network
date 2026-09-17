vpc_id = "vpc-0eb322f4c5bffad5b"

security_rules = {
  HTTP = {
    cidr_ipv4   = "0.0.0.0/0"
    from_port   = 80
    ip_protocol = "tcp"
    to_port     = 80
  }

  HTTPS = {
    cidr_ipv4   = "0.0.0.0/0"
    from_port   = 443
    ip_protocol = "tcp"
    to_port     = 443
  }

  SSH = {
    cidr_ipv4   = "46.205.209.17/32"
    from_port   = 22
    ip_protocol = "tcp"
    to_port     = 22
  }

  Grafana = {
    cidr_ipv4   = "0.0.0.0/0"
    from_port   = 3000
    ip_protocol = "tcp"
    to_port     = 3000
  }
}