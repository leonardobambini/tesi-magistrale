# resource "aws_instance" "ecommerce-prd-1" {
#   ami           = "ami-04be05782cc558e6b"
#   instance_type = "t2.micro"
#   key_name = "ecommerce"
#   subnet_id = var.subnet_prd_1_id
#   associate_public_ip_address = true

#   user_data = <<EOF
# #!/bin/bash
# cd ecommerce
# sudo python3 ecommerce.py
# EOF

#   vpc_security_group_ids = var.alb_sgs

#   tags = {
#     Name = "ecommerce-prd-1"
#   }

  
# }

# resource "aws_instance" "ecommerce-prd-2" {
#   ami           = "ami-04be05782cc558e6b"
#   instance_type = "t2.micro"
#   key_name = "ecommerce"
#   subnet_id = var.subnet_prd_2_id
#   associate_public_ip_address = true

# #   user_data = <<EOF
# # #!/bin/bash
# # sudo python3 ecommerce.py
# # EOF

#   vpc_security_group_ids = var.alb_sgs

#   tags = {
#     Name = "ecommerce-prd-2"
#   }

  
# }

resource "aws_instance" "ecommerce-dev" {
  ami           = "ami-04be05782cc558e6b"
  instance_type = "t2.micro"
  key_name = "ecommerce"
  subnet_id = var.subnet_dev_id

  vpc_security_group_ids = var.security_groups_dev

  tags = {
    Name = "ecommerce-dev"
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

# resource "aws_lb_target_group_attachment" "ecommerce-prd-1-tg-attachment" {
#   target_group_arn = aws_lb_target_group.ecommerce-tg.id
#   target_id        = aws_instance.ecommerce-prd-1.id
#   port             = 80
# }

# resource "aws_lb_target_group_attachment" "ecommerce-prd-2-tg-attachment" {
#   target_group_arn = aws_lb_target_group.ecommerce-tg.id
#   target_id        = aws_instance.ecommerce-prd-2.id
#   port             = 80
# }

resource "aws_lb_listener" "my_alb_listener" {
  load_balancer_arn = aws_lb.ecommerce-alb.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecommerce-tg.arn
 }

}

resource "aws_launch_template" "ecommerce_launch_template" {
  name = "ecommerce_launch_template"

  image_id = "ami-0f7204385566b32d0"

  instance_type = "t2.micro"

  key_name = "ecommerce"

  vpc_security_group_ids = var.alb_sgs

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "ecommerce"
    }
  }

  user_data = filebase64("${path.module}/nginx.sh")
}

resource "aws_autoscaling_group" "ecommerce_autoscaling_group" {
  name                      = "ecommerce_autoscaling_group2"
  max_size                  = 0
  min_size                  = 0
  health_check_grace_period = 300
  health_check_type         = "ELB"
  #desired_capacity          = 2
  force_delete              = true
  vpc_zone_identifier       = [var.subnet_prd_1_id, var.subnet_prd_2_id]
  target_group_arns = [aws_lb_target_group.ecommerce-tg.arn]

  instance_maintenance_policy {
    min_healthy_percentage = 90
    max_healthy_percentage = 120
  }

  tag {
    key                 = "App"
    value               = "ecommerce"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }

  launch_template {
    id = aws_launch_template.ecommerce_launch_template.id
  }
}

resource "aws_autoscaling_policy" "ecommerce_autoscaling_policy" {
  autoscaling_group_name = aws_autoscaling_group.ecommerce_autoscaling_group.name
  name                   = "ecommerce_autoscaling_policy"
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 70.0
  }
}
