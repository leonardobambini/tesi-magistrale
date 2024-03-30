output "ecommerce_prod_vpc_id" {
  value = aws_vpc.ecommerce_prod_vpc.id
}

output "ecommerce_prod_subnet1_id" {
  value = aws_subnet.ecommerce_prod_subnet1.id
}

output "ecommerce_prod_subnet2_id" {
  value = aws_subnet.ecommerce_prod_subnet2.id
}

output "ecommerce_dev_vpc_id" {
  value = aws_vpc.ecommerce_dev_vpc.id
}

output "ecommerce_dev_subnet_id" {
  value = aws_vpc.ecommerce_dev_vpc.id
}

output "ecommerce_sg_id" {
    value = aws_security_group.ecommerce-sg.id
}