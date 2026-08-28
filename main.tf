# Add your code here: 
resource "aws_subnet" "main" {
  vpc_id = var.vpc_id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "grafana"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = var.vpc_id

  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

resource "aws_route_table" "main" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

resource "aws_route_table_association" "main" {
  subnet_id = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "main" {
  name = "mate-aws-grafana-lab"
  vpc_id = var.vpc_id

  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.main.id

  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  ip_protocol = "tcp"
  to_port = 80
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.main.id

  cidr_ipv4 = "0.0.0.0/0"
  from_port = 443
  ip_protocol = "tcp"
  to_port = 443
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.main.id

  cidr_ipv4 = var.my_ip
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}

resource "aws_vpc_security_group_ingress_rule" "grafana" {
  security_group_id = aws_security_group.main.id
  
  cidr_ipv4          = "0.0.0.0/0"
  from_port           = 3000
  to_port             = 3000
  ip_protocol         = "tcp"
}

# 1. Create a subnet 
# 2. Create an Internet Gateway and attach it to the vpc
# 3. Configure routing for the Internet Gateway
# 4. Create a Security Group and inbound rules 
# 5. Uncommend (and update the value of security_group_id if required) outbound rule - it required 
# to allow outbound traffic from your virtual machine: 
resource "aws_vpc_security_group_egress_rule" "allow_all_eggress" {
  security_group_id = aws_security_group.main.id
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = -1
}
