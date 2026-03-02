variable "vpc_id" {
  type        = string
  description = "ID of the VPC, you deployed in the previous task."
}

variable "ssh_ingress_cidr_ipv4" {
  type        = string
  description = "IPv4 CIDR allowed to reach SSH."
}
