output "ecommerce_prd_vpc_id" {
  value = aws_vpc.ecommerce_prd_vpc.id
}

output "ecommerce_prd_subnet1_id" {
  value = aws_subnet.ecommerce_prd_subnet1.id
}

output "ecommerce_prd_subnet2_id" {
  value = aws_subnet.ecommerce_prd_subnet2.id
}

output "ecommerce_dev_vpc_id" {
  value = aws_vpc.ecommerce_dev_vpc.id
}

output "ecommerce_dev_subnet_id" {
  value = aws_subnet.ecommerce_dev_subnet.id
}

output "ecommerce_sg_id" {
    value = aws_security_group.ecommerce-sg.id
}

output "ecommerce_dev_sg_id" {
    value = aws_security_group.ecommerce-dev-sg.id
}

output "blog_prd_vpc_id" {
  value = aws_vpc.blog_prd_vpc.id
}

output "blog_prd_subnet_id" {
  value = aws_subnet.blog_prd_subnet.id
}

output "blog_dev_vpc_id" {
  value = aws_vpc.blog_dev_vpc.id
}

output "blog_dev_subnet_id" {
  value = aws_subnet.blog_dev_subnet.id
}

output "blog_sg_id" {
    value = aws_security_group.blog-sg.id
}

output "blog_dev_sg_id" {
    value = aws_security_group.blog-dev-sg.id
}