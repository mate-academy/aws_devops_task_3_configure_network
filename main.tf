resource "aws_subnet" "grafana" {
  vpc_id     = var.vpc_id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "grafana"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id
  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.grafana.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "security_group" {
  name   = "mate-aws-grafana-lab"
  vpc_id = var.vpc_id
  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

resource "aws_vpc_security_group_ingress_rule" "grafana_ingress" {
  security_group_id = aws_security_group.security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3000
  to_port           = 3000
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ssh_ingress" {
  security_group_id = aws_security_group.security_group.id
  cidr_ipv4         = "176.100.0.199/32"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_eggress" {
  security_group_id = aws_security_group.security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}