module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "ecs-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

module "ecs" {
  source = "./modules/ECS"

  cluster_name         = "nginx-cluster"
  ecs_sg_name          = "ecs-sg"
  ecs_sg_description   = "Allow HTTP traffic & traffic from ALB"
  vpc_id               = module.vpc.vpc_id
  ingress_cidr_blocks   = ["0.0.0.0/0"]
  alb_security_groups   = [module.sg.alb_sg_id]
  egress_cidr_blocks    = ["0.0.0.0/0"]
  
  task_cpu             = 256
  task_memory          = 512
  image_name           = "nginx"
  image                = "898896902478.dkr.ecr.us-west-2.amazonaws.com/nginx-app:latest"
  # secret_arn           = ""  

  service_name         = "nginx-service"
  desired_count        = 1
  subnets              = module.vpc.public_subnets
  security_groups      = [module.sg.ecs_sg_id]
  assign_public_ip     = true
  target_group_arn     = module.alb.alb_target_group_arn
  container_port       = 80
  alb_listener_dependency = module.alb.alb_listener_arn
}


module "alb" {
  source = "./modules/ALB"

  alb_name                = "nginx-alb"
  security_groups         = [module.sg.alb_sg_id]
  public_subnets          = module.vpc.public_subnets
  enable_deletion_protection = false
  tags = {
    Name        = "nginx-alb"
    Environment = "test"
  }

  vpc_id                     = module.vpc.vpc_id
  target_group_name           = "nginx-tg"
  target_group_port           = 80
  target_group_protocol       = "HTTP"
  target_type                 = "ip"
  health_check_path           = "/"
  health_check_interval       = 30
  health_check_timeout        = 5
  health_check_healthy_threshold   = 2
  health_check_unhealthy_threshold = 2

  listener_port        = 80
  listener_protocol    = "HTTP"
}

module "sg" {
  source = "./modules/SG"
  
  vpc_id        = module.vpc.vpc_id
  alb_sg_name   = "alb-sg"
  ecs_sg_name   = "ecs-sg"
  tags          = {
    Environment = "test"
  }
}




