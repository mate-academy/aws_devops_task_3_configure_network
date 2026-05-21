resource "aws_subnet" "subnet" {
  vpc_id     = var.vpc_id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "grafana"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = var.vpc_id

  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

resource "aws_route_table_association" "route_table_association" {
  route_table_id = aws_route_table.route_table.id
  subnet_id      = aws_subnet.subnet.id
}

resource "aws_security_group" "security_group" {
  name   = "mate-aws-grafana-lab"
  vpc_id = var.vpc_id

  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.security_group.id

  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 3000
  to_port     = 3000
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.security_group.id

  ip_protocol = "tcp"
  cidr_ipv4   = "91.211.133.0/24"
  from_port   = 22
  to_port     = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_eggress" {
  security_group_id = aws_security_group.security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1
}
