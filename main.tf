resource "aws_subnet" "grafana" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "eu-central-1a"

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

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.grafana_igw.id
  }

  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

resource "aws_route_table_association" "grafana_rta" {
  subnet_id      = aws_subnet.grafana.id
  route_table_id = aws_route_table.grafana_rt.id
}

resource "aws_security_group" "grafana_sg" {
  name        = "mate-aws-grafana-lab"
  description = "Allow HTTP, HTTPS, SSH to Grafana"
  vpc_id      = var.vpc_id

  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

resource "aws_security_group_rule" "allow_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.grafana_sg.id
}

resource "aws_security_group_rule" "allow_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.grafana_sg.id
}

resource "aws_vpc_security_group_egress_rule" "egress" {
  security_group_id = aws_security_group.grafana_sg.id

  ip_protocol = "-1"
  from_port   = 0
  to_port     = 0
  cidr_ipv4   = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.grafana_sg.id

  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
  cidr_ipv4   = "185.136.134.23/32"
}

resource "aws_vpc_security_group_ingress_rule" "grafana" {
  security_group_id = aws_security_group.grafana_sg.id

  ip_protocol = "tcp"
  from_port   = 3000
  to_port     = 3000
  cidr_ipv4   = "0.0.0.0/0"
}