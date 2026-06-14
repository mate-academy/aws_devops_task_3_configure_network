variable "vpc_id" {
  type        = string
  description = "ID of the VPC, you deployed in the previous task."
}


variable "rules" {
  default = {
    SSH = {
      "cidr_ipv4"   = "46.205.210.105/32"
      "port"        = 22
      "ip_protocol" = "tcp"
    }
    HTTP = {
      "cidr_ipv4"   = "0.0.0.0/0"
      "port"        = 80
      "ip_protocol" = "tcp"
    }
    HTTPS = {
      "cidr_ipv4"   = "0.0.0.0/0"
      "port"        = 443
      "ip_protocol" = "tcp"
    }
    grafana = {
      "cidr_ipv4"   = "0.0.0.0/0"
      "port"        = 3000
      "ip_protocol" = "tcp"
    }
  }
}