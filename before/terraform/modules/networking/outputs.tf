output "webapp_prod_vpc_id" {
  value = aws_vpc.webapp_prod_vpc.id
}

output "webapp_prod_subnet1_id" {
  value = aws_subnet.webapp_prod_subnet1.id
}

output "webapp_prod_subnet2_id" {
  value = aws_subnet.webapp_prod_subnet2.id
}

output "webapp_dev_vpc_id" {
  value = aws_vpc.webapp_dev_vpc.id
}

output "webapp_dev_subnet_id" {
  value = aws_vpc.webapp_dev_vpc.id
}