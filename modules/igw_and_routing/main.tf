resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id
}

resource "aws_route_table" "public_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  depends_on = [
    aws_internet_gateway.igw
  ]
}

resource "aws_route_table_association" "subnet_a_association" {
  subnet_id      = var.subnet_ids[0]
  route_table_id = aws_route_table.public_rt.id

  depends_on = [
    aws_route_table.public_rt
  ]
}

resource "aws_route_table_association" "subnet_b_association" {
  subnet_id      = var.subnet_ids[1]
  route_table_id = aws_route_table.public_rt.id

  depends_on = [
    aws_route_table.public_rt
  ]
}