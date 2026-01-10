resource "aws_subnet" "grafana" {
  vpc_id     = var.vpc_id
  cidr_block = "10.0.10.0/24"

  tags = {
    Name = "grafana"
  }
}

resource "aws_internet_gateway" "grafana" {
  vpc_id = var.vpc_id

  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

resource "aws_route_table" "grafana" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.grafana.id
  }

  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

resource "aws_route_table_association" "grafana" {
  subnet_id      = aws_subnet.grafana.id
  route_table_id = aws_route_table.grafana.id
}

resource "aws_security_group" "grafana" {
  name   = "mate-aws-grafana-lab"
  vpc_id = var.vpc_id

  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.grafana.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.grafana.id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.grafana.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "84.232.141.182/32"
}

resource "aws_vpc_security_group_ingress_rule" "grafana_ui" {
  security_group_id = aws_security_group.grafana.id
  ip_protocol       = "tcp"
  from_port         = 3000
  to_port           = 3000
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.grafana.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
