resource "aws_vpc" "lab_vpc" {
  cidr_block = "10.10.0.0/16"
  tags = {
    Name = "mate-aws-grafana-lab-vpc"
  }
}

resource "aws_subnet" "grafana" {
  vpc_id            = aws_vpc.lab_vpc.id
  cidr_block        = "10.10.1.0/24"
  availability_zone = "eu-central-1a"

  tags = {
    Name = "grafana"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.lab_vpc.id

  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.lab_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.grafana.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "sg" {
  name        = "mate-aws-grafana-lab"
  description = "Security group for Grafana lab"
  vpc_id      = aws_vpc.lab_vpc.id

  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_grafana" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3000
  ip_protocol       = "tcp"
  to_port         = 3000
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = "95.10.20.30/32" # Сюда строго один IP с маской /32
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
