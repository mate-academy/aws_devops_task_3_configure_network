variable "vpc_id" {
  type        = string
  description = "ID of the VPC, you deployed in the previous task."
}

variable "security_rules" {
  type = map(object({
    cidr_ipv4   = string
    from_port   = number
    ip_protocol = string
    to_port     = number
  }))
  description = "List of security rules for the network security group"
}