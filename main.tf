# Add your code here:


resource "aws_subnet" "example" {
  vpc_id     = var.vpc_id
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "grafana"
  }
}

resource "aws_internet_gateway" "example" {
  vpc_id = var.vpc_id
  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

resource "aws_route_table" "example" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = resource.aws_internet_gateway.example.id
  }
  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

resource "aws_route_table_association" "example" {
  subnet_id      = resource.aws_subnet.example.id
  route_table_id = resource.aws_route_table.example.id
}

resource "aws_security_group" "example" {
  name   = "mate-aws-grafana-lab"
  vpc_id = var.vpc_id
  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

resource "aws_vpc_security_group_ingress_rule" "example" {
  for_each          = var.rules
  security_group_id = resource.aws_security_group.example.id

  cidr_ipv4   = each.value.cidr_ipv4
  ip_protocol = each.value.ip_protocol
  from_port   = each.value.port
  to_port     = each.value.port
}

# resource "aws_vpc_security_group_ingress_rule" "mate-aws-grafana-lab" {

# }

# 1. Create a subnet
# 2. Create an Internet Gateway and attach it to the vpc
# 3. Configure routing for the Internet Gateway
# 4. Create a Security Group and inbound rules
# 5. Uncommend (and update the value of security_group_id if required) outbound rule - it required
# to allow outbound traffic from your virtual machine:
resource "aws_vpc_security_group_egress_rule" "allow_all_eggress" {
  security_group_id = resource.aws_security_group.example.id
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = -1
}

