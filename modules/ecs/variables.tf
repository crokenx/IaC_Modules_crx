variable "capacity" {
  type = string
  nullable    = false
}

variable "task_execution_role_arn" {
  type = string
  nullable    = false
}

variable "subnets" {
  type = list(string)
  nullable    = false
}

variable "alb_target_group_arn" {
  type = string
  nullable    = false
}

variable "ecr_repository_url" {
  type = string
  nullable    = false
}

variable "rds_endpoint" {
  type = string
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

variable "db_name" {
  type = string
  nullable    = false
}