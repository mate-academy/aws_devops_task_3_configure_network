variable "vpc_id" {
    type = string
    description = "ID of the VPC, you deployed in the previous task."
}

variable "my_ip" {
    type = string
    description = "Your public IP address for SSH access (without /32 suffix)."
}
