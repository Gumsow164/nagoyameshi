#---------------------------------
# Application Load Balancer
#---------------------------------
resource "aws_lb" "laravel_alb" {
  name               = "${var.project}-${var.enviroment}-laravel-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_sg.id]
  subnets            = [aws_subnet.public_subnet_1a.id, aws_subnet.public_subnet_1c.id]

  enable_deletion_protection = false

  tags = {
    Name        = "${var.project}-${var.enviroment}-laravel-alb"
    Project     = var.project
    Environment = var.enviroment
  }
}

#---------------------------------
# Target Group
#---------------------------------
resource "aws_lb_target_group" "laravel_tg" {
  name        = "${var.project}-${var.enviroment}-laravel-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.dev_vpc.id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "${var.project}-${var.enviroment}-laravel-tg"
    Project     = var.project
    Environment = var.enviroment
  }
}

#---------------------------------
# ALB Listener
#---------------------------------
resource "aws_lb_listener" "laravel_listener" {
  load_balancer_arn = aws_lb.laravel_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.laravel_tg.arn
  }
}

#---------------------------------
# ALB Listener Rule (Optional: for path-based routing)
#---------------------------------
resource "aws_lb_listener_rule" "laravel_rule" {
  listener_arn = aws_lb_listener.laravel_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.laravel_tg.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

#---------------------------------
# Outputs
#---------------------------------
output "alb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.laravel_alb.dns_name
}

output "alb_zone_id" {
  description = "The canonical hosted zone ID of the load balancer"
  value       = aws_lb.laravel_alb.zone_id
}

output "target_group_arn" {
  description = "The ARN of the target group"
  value       = aws_lb_target_group.laravel_tg.arn
}
