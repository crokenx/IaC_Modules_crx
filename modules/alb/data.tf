data "aws_security_group" "sg_alb" {
  filter {
    name   = "tag:Name"
    values = ["${var.capacity}-alb-security-group"]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.target_vpc.id]
  }
  
}

data "aws_vpc" "target_vpc" {
  filter {
    name   = "tag:Name"
    values = ["co-main-vpc"]
  }
}
