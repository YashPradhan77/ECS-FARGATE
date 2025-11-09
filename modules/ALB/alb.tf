resource "aws_lb" "nginx-alb" {
  name               = var.alb_name
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.public_subnets

  enable_deletion_protection = var.enable_deletion_protection

  tags = var.tags
}

resource "aws_alb_target_group" "nginx-tg" {
  name        = var.target_group_name
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  vpc_id      = var.vpc_id
  target_type = var.target_type

  health_check {
    path                = var.health_check_path
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.nginx-alb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.nginx-tg.arn
  }
}
