output "alb_DNS_Name" {
  description = "The DNS name of the ALB"
  value = aws_lb.nginx-alb.dns_name
}

output "alb_arn" {
  description = "The ARN of the Application Load Balancer"
  value       = aws_lb.nginx-alb.arn
}

output "alb_target_group_arn" {
  description = "The ARN of the target group"
  value       = aws_alb_target_group.nginx-tg.arn
}

output "alb_listener_arn" {
  description = "The ARN of the ALB Listener"
  value       = aws_alb_listener.http.arn
}