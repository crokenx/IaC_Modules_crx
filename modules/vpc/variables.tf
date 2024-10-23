variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
  nullable    = false
}

variable "subnet_a_cidr" {
  type    = string
  default = "10.0.1.0/24"
  nullable    = false
}

variable "subnet_b_cidr" {
  type    = string
  default = "10.0.2.0/24"
  nullable    = false
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
  nullable    = false
}

variable "tags" {
  type = map(string)
  default = {
    Name = "Main VPC"
  }
}