variable "vpc_id" {
  type = string
  nullable    = false
}

variable "subnet_ids" {
  type = list(string)
  nullable    = false
}