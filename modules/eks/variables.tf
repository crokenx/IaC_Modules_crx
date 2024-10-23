variable "cluster_name" {
  type    = string
  default = "franchise-eks-cluster"
}

variable "node_group_name" {
  type    = string
  default = "franchise-node-group"
}

variable "cluster_role_arn" {
  type = string
}

variable "node_role_arn" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "desired_size" {
  type    = number
  default = 2
}

variable "max_size" {
  type    = number
  default = 3
}

variable "min_size" {
  type    = number
  default = 1
}