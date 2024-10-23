variable "vpc_id" {
  type = string
  nullable    = false
}

variable "subnets" {
  type = list(string)
  nullable    = false
}

variable "security_group" {
  type = string
  nullable    = false
}

variable "capacity" {
  type = string
  nullable    = false
}