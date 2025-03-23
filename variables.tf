variable "vpc_id" {
  type        = string
  description = "ID of the VPC, you deployed in the previous task."
}

variable "resource_name" {
  type        = string
  description = "The name of the AWS resources used in this configuration."
}

variable "subnet_name" {
  type        = string
  description = "The name assigned to the subnet."
}

variable "subnet_cidr" {
  type        = string
  description = "The CIDR block assigned to the subnet."
}

variable "allow_trafic" {
  type = map(object({
    from = number
    to   = number
    cidr = string
  }))
  description = "A map of allowed traffic rules with port ranges and CIDR blocks."
}