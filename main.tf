# Add your code here: 
resource "aws_subnet" "subnet" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "eu-central-1a"
  tags = {
    "Name" = "grafana"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id
  tags = {
    "Name" = "mate-aws-grafana-lab"
  }
}
resource "aws_route_table" "route_table" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

# resource "aws_route" "internet_access" {
#   route_table_id         = aws_route_table.route_table.id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.igw.id
# }
resource "aws_route_table_association" "subnet_association" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.route_table.id
}
resource "aws_security_group" "security_group" {
  vpc_id = var.vpc_id
  tags = {
    "Name" = "mate-aws-grafana-lab"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http_s_grafana" {
  security_group_id = aws_security_group.security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 3000
  ip_protocol       = "tcp"
}


resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.security_group.id
  cidr_ipv4         = "130.0.43.163/32"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}
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
