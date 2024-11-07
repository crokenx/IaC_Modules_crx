variable "cluster_name" {
  type    = string
  nullable    = false
}

variable "node_group_name" {
  type    = string
  nullable    = false
}

variable "cluster_role_arn" {
  type = string
  nullable    = false
}

variable "node_role_arn" {
  type = string
  nullable    = false
}

variable "subnet_ids" {
  type = list(string)
  nullable    = false
}

variable "desired_size" {
  type    = number
  default = 2
  nullable    = false
}

variable "max_size" {
  type    = number
  default = 3
  nullable    = false
}

variable "min_size" {
  type    = number
  default = 1
  nullable    = false
}