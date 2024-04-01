resource "aws_instance" "blog-prd" {
  ami           = "ami-04be05782cc558e6b"
  instance_type = "t2.micro"
  key_name = "blog"
  subnet_id = var.subnet_prd_id

  user_data = <<EOF
#!/bin/bash
sudo python3 ecommerce.py
EOF

  vpc_security_group_ids = var.security_groups

  tags = {
    Name = "blog1"
  }

}

resource "aws_instance" "blog-dev" {
  ami           = "ami-04be05782cc558e6b"
  instance_type = "t2.micro"
  key_name = "blog"
  subnet_id = var.subnet_dev_id

  vpc_security_group_ids = var.security_groups_dev

  tags = {
    Name = "blog2"
  }

  
}
