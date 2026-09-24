# 1. Subnet for the future Grafana EC2 instance
resource "aws_subnet" "grafana" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "grafana"
  }
}

# 2. Internet Gateway — lets the VPC reach the public Internet
resource "aws_internet_gateway" "gw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

# 3. Route table — send all non-local traffic via the Internet Gateway
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

# 4. Attach the route table to the grafana subnet (makes it a public subnet)
resource "aws_route_table_association" "grafana" {
  subnet_id      = aws_subnet.grafana.id
  route_table_id = aws_route_table.public.id
}

# 5. Security group — firewall for the Grafana VM
resource "aws_security_group" "security_group" {
  name   = "mate-aws-grafana-lab"
  vpc_id = var.vpc_id

  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

# 6a. Allow Grafana UI (port 3000) from anywhere
resource "aws_vpc_security_group_ingress_rule" "allow_grafana" {
  security_group_id = aws_security_group.security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3000
  to_port           = 3000
  ip_protocol       = "tcp"
}

# 6b. Allow SSH only from your public IP
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.security_group.id
  cidr_ipv4         = "194.26.166.20/32"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

# 7. Allow all outbound traffic from the VM (updates, package installs, etc.)
resource "aws_vpc_security_group_egress_rule" "allow_all_eggress" {
  security_group_id = aws_security_group.security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1
}
