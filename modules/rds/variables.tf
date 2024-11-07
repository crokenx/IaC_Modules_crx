variable "subnet_ids" {
  type = list(string)
  nullable    = false
}

variable "db_username" {
  type = string
  nullable    = false
}

variable "db_password" {
  type = string
  nullable    = false
}

variable "capacity" {
  type = string
  nullable    = false
}