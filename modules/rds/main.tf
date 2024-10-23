resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.capacity}-rds-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "instance_rds" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "16.2"
  instance_class       = "db.t3.micro"
  db_name              = "${var.capacity}db"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = aws_db_parameter_group.rds_parameter_group.name
  skip_final_snapshot  = true
  publicly_accessible  = true
  multi_az             = false
  vpc_security_group_ids = [var.security_group]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name

  depends_on = [
    aws_db_subnet_group.rds_subnet_group
  ]
}

resource "aws_db_parameter_group" "rds_parameter_group" {
  name        = "${var.capacity}-rds-parameter-group"
  family      = "postgres16"
  description = "Custom parameter group for ${var.capacity} RDS"

  parameter {
    name  = "rds.force_ssl"
    value = "0"
  }
}
