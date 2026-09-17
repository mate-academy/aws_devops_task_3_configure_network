# Add your code here: 

# 1. Create a subnet
# 2. Create an Internet Gateway and attach it to the vpc
# 3. Configure routing for the Internet Gateway
# 4. Create a Security Group and inbound rules
# 5. Uncommend (and update the value of security_group_id if required) outbound rule - it required
# to allow outbound traffic from your virtual machine:

resource "aws_vpc_security_group_egress_rule" "allow_all_eggress" {
  security_group_id = aws_security_group.security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1
}


resource "aws_subnet" "subnet" {
  vpc_id     = var.vpc_id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "grafana"
  }

}

resource "aws_internet_gateway" "gw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

resource "aws_route_table_association" "route_table_association" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_security_group" "security_group" {
  name        = "mate-aws-grafana-lab"
  description = "Task 2 NSG"
  vpc_id      = var.vpc_id

  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

resource "aws_vpc_security_group_ingress_rule" "example" {
  security_group_id = aws_security_group.security_group.id

  for_each = var.security_rules

  cidr_ipv4   = each.value.cidr_ipv4
  from_port   = each.value.from_port
  ip_protocol = each.value.ip_protocol
  to_port     = each.value.to_port

}