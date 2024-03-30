resource "aws_db_instance" "webapp-db" {
  allocated_storage    = 10
  db_name              = "webapp-db"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  username             = var.db_username
  password             = var.db_password
  skip_final_snapshot  = true
}