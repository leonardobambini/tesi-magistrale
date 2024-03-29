resource "aws_instance" "web" {
  ami           = "ami-06cbfd22d52e19656"
  instance_type = "t2.micro"
  key_name = "webapp"

  tags = {
    Name = "Webapp"
  }

  
}