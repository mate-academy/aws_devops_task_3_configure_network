resource "aws_subnet" "main" {
  vpc_id     = var.vpc_id
  cidr_block = "10.10.10.0/24"

  tags = {
    Name = "Grafana"
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

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_security_group" "allow_tls" {
  name = "mate-aws-grafana-lab"
  description = "allow tls traffic"
  vpc_id = var.vpc_id

  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.allow_tls.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.allow_tls.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.allow_tls.id

  cidr_ipv4   = "45.137.78.18/32"
  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_grafana" {
  security_group_id = aws_security_group.allow_tls.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 3000
  to_port     = 3000
}
# Add your code here:

# 1. Create a subnet 
# 2. Create an Internet Gateway and attach it to the vpc
# 3. Configure routing for the Internet Gateway
# 4. Create a Security Group and inbound rules 
# 5. Uncommend (and update the value of security_group_id if required) outbound rule - it required 
# to allow outbound traffic from your virtual machine: 
resource "aws_vpc_security_group_egress_rule" "allow_all_egress" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = -1
}

# resource "aws_security_group_rule" "egress_https" {
#   type        = "egress"
#   protocol    = "tcp"
#   from_port   = 443
#   to_port     = 443
#   cidr_blocks = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.allow_tls.id
# }
# resource "aws_security_group_rule" "egress_dns" {
#   type        = "egress"
#   protocol    = "udp"
#   from_port   = 53
#   to_port     = 53
#   cidr_blocks = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.allow_tls.id
# }
