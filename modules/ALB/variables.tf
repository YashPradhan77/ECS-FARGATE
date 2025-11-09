variable "alb_name" {
  description = "The name of the Application Load Balancer"
  type        = string
}

variable "security_groups" {
  description = "Security groups to associate with the ALB"
  type        = list(string)
}

variable "public_subnets" {
  description = "Public subnets for the ALB"
  type        = list(string)
}

variable "enable_deletion_protection" {
  description = "Whether to enable deletion protection for the ALB"
  type        = bool
}

variable "tags" {
  description = "Tags for the ALB"
  type        = map(string)
}

variable "vpc_id" {
  description = "VPC ID for the ALB and security group"
  type        = string
}

variable "target_group_name" {
  description = "Name of the target group"
  type        = string
}

variable "target_group_port" {
  description = "Port for the target group"
  type        = number
}

variable "target_group_protocol" {
  description = "Protocol for the target group"
  type        = string
}

variable "target_type" {
  description = "Type of target for the target group"
  type        = string
}

variable "health_check_path" {
  description = "Path for the health check"
  type        = string
}

variable "health_check_interval" {
  description = "Interval for the health check in seconds"
  type        = number
}

variable "health_check_timeout" {
  description = "Timeout for the health check in seconds"
  type        = number
}

variable "health_check_healthy_threshold" {
  description = "Number of successful health checks to mark the target as healthy"
  type        = number
}

variable "health_check_unhealthy_threshold" {
  description = "Number of failed health checks to mark the target as unhealthy"
  type        = number
}

variable "listener_port" {
  description = "Port for the ALB listener"
  type        = number
}

variable "listener_protocol" {
  description = "Protocol for the ALB listener"
  type        = string
}
