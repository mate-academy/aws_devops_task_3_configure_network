# Add your code here: 

# 1. Create a subnet 
# 2. Create an Internet Gateway and attach it to the vpc
# 3. Configure routing for the Internet Gateway
# 4. Create a Security Group and inbound rules 
# 5. Uncommend (and update the value of security_group_id if required) outbound rule - it required 
# to allow outbound traffic from your virtual machine: 
# resource "aws_vpc_security_group_egress_rule" "allow_all_eggress" {
#   security_group_id = aws_security_group.security_group.id
#   cidr_ipv4   = "0.0.0.0/0"
#   ip_protocol = -1
# }

resource "aws_subnet" "main" {
  vpc_id     = var.vpc_id
  cidr_block = "10.0.64.0/18"

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

resource "aws_route_table" "rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }


  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "asg" {
  name        = "mate-aws-grafana-lab"
  description = "Allow HTTP, HTTPS, SSH"
  vpc_id      = var.vpc_id

  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_grafana" {
  security_group_id = aws_security_group.asg.id 

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 3000
  to_port     = 3000
  ip_protocol = "tcp"
}


resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.asg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.asg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

data "http" "my_ip" {
  url = "http://checkip.amazonaws.com"
}

locals {
  my_ip_cidr = "${chomp(data.http.my_ip.response_body)}/32"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.asg.id
  cidr_ipv4         = local.my_ip_cidr
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

 resource "aws_vpc_security_group_egress_rule" "allow_all_eggress" {
   security_group_id = aws_security_group.asg.id
   cidr_ipv4   = "0.0.0.0/0"
   ip_protocol = -1
 }
