resource "aws_subnet" "grafana_subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "grafana"
  }
}

resource "aws_internet_gateway" "grafana_igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

resource "aws_route_table" "grafana_rt" {
  vpc_id = var.vpc_id

  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

resource "aws_route" "grafana_inet_route" {
  route_table_id         = aws_route_table.grafana_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.grafana_igw.id
}

resource "aws_route_table_association" "grafana_rt_assoc" {
  subnet_id      = aws_subnet.grafana_subnet.id
  route_table_id = aws_route_table.grafana_rt.id
}

resource "aws_security_group" "grafana_sg" {
  name        = "mate-aws-grafana-lab"
  description = "Security group for Grafana lab - updated"
  vpc_id      = var.vpc_id

  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.grafana_sg.id
  cidr_ipv4         = "78.26.151.40/32"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.grafana_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "grafana_port" {
  security_group_id = aws_security_group.grafana_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3000
  to_port           = 3000
  ip_protocol       = "tcp"
}
