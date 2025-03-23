resource "aws_subnet" "main" {
  vpc_id     = var.vpc_id
  cidr_block = var.subnet_cidr

  tags = {
    Name = var.subnet_name
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = var.vpc_id

  tags = {
    Name = var.resource_name
  }
}

resource "aws_route_table" "example" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = var.resource_name
  }
}

resource "aws_route_table_association" "subnet" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.example.id
}

resource "aws_security_group" "sg" {
  vpc_id = var.vpc_id

  tags = {
    Name = var.resource_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "trafic" {
  for_each = var.allow_trafic

  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = each.value.cidr
  from_port         = each.value.from
  to_port           = each.value.to
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_eggress" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1
}
