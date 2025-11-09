variable "vpc_id" {
  description = "The ID of the VPC where the security groups will be created"
  type        = string
}

variable "alb_sg_name" {
  description = "Name of the ALB security group"
  type        = string
  default     = "alb-sg"
}

variable "ecs_sg_name" {
  description = "Name of the ECS security group"
  type        = string
  default     = "ecs-sg"
}

variable "tags" {
  description = "Tags to apply to the security groups"
  type        = map(string)
  default     = {
    Environment = "test"
  }
}
