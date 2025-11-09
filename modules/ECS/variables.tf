# Cluster variables
variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

# Security Group variables
variable "ecs_sg_name" {
  description = "Name for the ECS security group"
  type        = string
}

variable "ecs_sg_description" {
  description = "Description for the ECS security group"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where ECS will run"
  type        = string
}

variable "ingress_cidr_blocks" {
  description = "CIDR blocks for ingress traffic"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "alb_security_groups" {
  description = "Security group IDs for ALB"
  type        = list(string)
}

variable "egress_cidr_blocks" {
  description = "CIDR blocks for egress traffic"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# Task definition variables
variable "task_cpu" {
  description = "CPU units for the ECS task"
  type        = number
}

variable "task_memory" {
  description = "Memory (in MiB) for the ECS task"
  type        = number
}

variable "image_name" {
  description = "Name of the Docker container"
  type        = string
}

variable "image" {
  description = "Docker image to be used for the container"
  type        = string
}

# ECS Service variables
variable "service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "desired_count" {
  description = "Number of tasks to run in the service"
  type        = number
}

variable "subnets" {
  description = "List of subnets for ECS tasks"
  type        = list(string)
}

variable "security_groups" {
  description = "List of security group IDs for ECS tasks"
  type        = list(string)
}

variable "assign_public_ip" {
  description = "Assign a public IP address to ECS tasks"
  type        = bool
}

variable "target_group_arn" {
  description = "ARN of the ALB target group"
  type        = string
}

variable "container_port" {
  description = "Container port to be exposed"
  type        = number
}

variable "alb_listener_dependency" {
  description = "ALB listener dependency to ensure ECS service waits for the ALB to be ready"
  type        = any
}

variable "secret_arn" {
  description = "ARN of the Secrets Manager secret"
  type        = string
}