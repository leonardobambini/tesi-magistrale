resource "aws_vpc" "ecommerce_prod_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "ecommerce_prod_subnet1" {
  vpc_id     = aws_vpc.ecommerce_prod_vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "ecommerce_prod_subnet2" {
  vpc_id     = aws_vpc.ecommerce_prod_vpc.id
  cidr_block = "10.0.2.0/24"
}

resource "aws_vpc" "ecommerce_dev_vpc" {
  cidr_block = "10.1.0.0/16"
}

resource "aws_subnet" "ecommerce_dev_subnet" {
  vpc_id     = aws_vpc.ecommerce_dev_vpc.id
  cidr_block = "10.1.1.0/24"
}

resource "aws_security_group" "ecommerce-sg" {
  name        = "ecommerce-sg"
  description = "Security group for the ecommerce webapp"
  vpc_id      = aws_vpc.ecommerce_prod_vpc.id

  tags = {
    Name = "ecommerce-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.ecommerce-sg.id
  cidr_ipv4         = aws_vpc.ecommerce_prod_vpc.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.ecommerce-sg.id
  cidr_ipv4         = aws_vpc.ecommerce_prod_vpc.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.ecommerce-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}