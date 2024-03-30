resource "aws_instance" "ecommerce-prod-1" {
  ami           = "ami-06cbfd22d52e19656"
  instance_type = "t2.micro"
  key_name = "ecommerce"

  tags = {
    Name = "ecommerce1"
  }

  
}

resource "aws_instance" "ecommerce-prod-2" {
  ami           = "ami-06cbfd22d52e19656"
  instance_type = "t2.micro"
  key_name = "ecommerce"

  tags = {
    Name = "ecommerce2"
  }

  
}

resource "aws_instance" "ecommerce-dev" {
  ami           = "ami-06cbfd22d52e19656"
  instance_type = "t2.micro"
  key_name = "ecommerce"

  tags = {
    Name = "ecommerce2"
  }

  
}

resource "aws_lb" "ecommerce-alb" {
  name               = "ecommerce-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.alb_sgs
  subnets            = var.alb_subnets

  enable_deletion_protection = false

}

resource "aws_lb_target_group" "ecommerce-tg" {
  name     = "ecommerce-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "ecommerce-prod-1-tg-attachment" {
  target_group_arn = aws_lb_target_group.ecommerce-tg.id
  target_id        = aws_instance.ecommerce-prod-1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "ecommerce-prod-2-tg-attachment" {
  target_group_arn = aws_lb_target_group.ecommerce-tg.id
  target_id        = aws_instance.ecommerce-prod-2.id
  port             = 80
}

resource "aws_lb_listener" "my_alb_listener" {
  load_balancer_arn = aws_lb.ecommerce-alb.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecommerce-tg.arn
 }

}



