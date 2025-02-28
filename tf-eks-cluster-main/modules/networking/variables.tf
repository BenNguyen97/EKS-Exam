variable "vpc_cidr_block" {
  type    = string
  default = "10.1.0.0/16"
}
variable "vpc_name" {
  type    = string
  default = "le-vpc-25dec-01"
}

variable "tag" {
  description = "Tags value"
  type        = map(string)
  default     = {
    Costcenter = "devops2402"
  }
}

variable "sn01_cidr_block" {
  type    = string
  default = "10.1.1.0/24"
}

variable "sn_public_01_cidr_block" {
  type    = string
  default = "10.1.1.0/24"
}
variable "sn_public_02_cidr_block" {
  type    = string
  default = "10.1.3.0/24"
}

variable "sn_private_01_cidr_block" {
  type    = string
  default = "10.1.5.0/24"
}
variable "sn_private_02_cidr_block" {
  type    = string
  default = "10.1.7.0/24"
}
variable "az_public_01" {
  type    = string
  default = "ap-southeast-2a"
}
variable "az_public_02" {
  type    = string
  default = "ap-southeast-2b"
}
variable "az_private_01" {
  type    = string
  default = "ap-southeast-2a"
}
variable "az_private_02" {
  type    = string
  default = "ap-southeast-2b"
}
variable "public_ip_on_launch" {
  type    = bool
  default = true
}