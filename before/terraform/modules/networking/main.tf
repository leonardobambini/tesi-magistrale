resource "aws_vpc" "webapp_prod_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "webapp_prod_subnet1" {
  vpc_id     = aws_vpc.webapp_prod_vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "webapp_prod_subnet2" {
  vpc_id     = aws_vpc.webapp_prod_vpc.id
  cidr_block = "10.0.2.0/24"
}

resource "aws_vpc" "webapp_dev_vpc" {
  cidr_block = "10.1.0.0/16"
}

resource "aws_subnet" "webapp_dev_subnet" {
  vpc_id     = aws_vpc.webapp_dev_vpc.id
  cidr_block = "10.1.1.0/24"
}