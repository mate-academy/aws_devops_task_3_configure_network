resource "aws_subnet" "main" {
  vpc_id     = var.vpc_id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "grafana"
  }
}

resource "aws_internet_gateway" "mate-aws-grafana-lab" {
  vpc_id = var.vpc_id

  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

resource "aws_route_table" "mate-aws-grafana-lab" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mate-aws-grafana-lab.id
  }

  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

resource "aws_route_table_association" "mate-aws-grafana-lab" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.mate-aws-grafana-lab.id
}

resource "aws_security_group" "mate-aws-grafana-lab" {
  name        = "mate-aws-grafana-lab"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "mate-aws-grafana-lab"
  }

}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
    security_group_id = aws_security_group.mate-aws-grafana-lab.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
    security_group_id = aws_security_group.mate-aws-grafana-lab.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 443
    to_port = 443
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
    security_group_id = aws_security_group.mate-aws-grafana-lab.id
    cidr_ipv4 = var.public_ip
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_grafana" {
    security_group_id = aws_security_group.mate-aws-grafana-lab.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 3000
    to_port = 3000
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_eggress" {
  security_group_id = aws_security_group.mate-aws-grafana-lab.id
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}
