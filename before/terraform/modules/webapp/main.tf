resource "aws_instance" "webapp-prod-1" {
  ami           = "ami-06cbfd22d52e19656"
  instance_type = "t2.micro"
  key_name = "webapp"

  tags = {
    Name = "Webapp1"
  }

  
}

resource "aws_instance" "webapp-prod-2" {
  ami           = "ami-06cbfd22d52e19656"
  instance_type = "t2.micro"
  key_name = "webapp"

  tags = {
    Name = "Webapp2"
  }

  
}

resource "aws_instance" "webapp-dev" {
  ami           = "ami-06cbfd22d52e19656"
  instance_type = "t2.micro"
  key_name = "webapp"

  tags = {
    Name = "Webapp2"
  }

  
}

resource "aws_lb" "webapp-alb" {
  name               = "webapp-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.alb_sgs
  subnets            = var.alb_subnets

  enable_deletion_protection = false

}

resource "aws_lb_target_group" "webapp-tg" {
  name     = "webapp-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "webapp-prod-1-tg-attachment" {
  target_group_arn = aws_lb_target_group.webapp-tg.id
  target_id        = aws_instance.webapp-prod-1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "webapp-prod-2-tg-attachment" {
  target_group_arn = aws_lb_target_group.webapp-tg.id
  target_id        = aws_instance.webapp-prod-2.id
  port             = 80
}

resource "aws_lb_listener" "my_alb_listener" {
  load_balancer_arn = aws_lb.webapp-alb.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webapp-tg.arn
 }

}



