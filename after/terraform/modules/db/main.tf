resource "aws_db_instance" "ecommerce-db" {
  allocated_storage    = 10
  db_name              = "ecommercedb"
  engine               = "mysql"
  instance_class       = "db.t3.micro"
  username             = var.db_username
  password             = var.db_password
  skip_final_snapshot  = true

  tags = {
    Project = "ecommerce"
    Team = "devops"
    Environment = "prd"
  }
}