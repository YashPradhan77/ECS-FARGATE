resource "aws_ecs_cluster" "nginx-cluster" {
  name = var.cluster_name
}

resource "aws_iam_role" "ecs_task_role" {
  name = "ecs_task_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Basic permissions required for ECS Exec (SSM session)
resource "aws_iam_role_policy" "ecs_task_exec_permissions" {
  name = "ecs-task-exec-permissions"
  role = aws_iam_role.ecs_task_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }]
  })
}

resource "aws_iam_role_policy" "ecs_secrets_access" {
  name = "ECSSecretsAccess"
  role = aws_iam_role.ecs_task_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue"
        ],
        Resource = [
          var.secret_arn  # Pass your Secrets Manager ARN via variable
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "nginx-task-def" {
  family                   = "nginx"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn 

  container_definitions = jsonencode([{
    name      = var.image_name
    image     = var.image
    cpu       = var.task_cpu
    memory    = var.task_memory
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]
    # secrets = [{
    #   name      = "demo"  # Environment variable name inside the container
    #   valueFrom = var.secret_arn
    # }]
  }])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }
}

resource "aws_ecs_service" "nginx" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.nginx-cluster.id
  task_definition = aws_ecs_task_definition.nginx-task-def.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"
  depends_on      = [var.alb_listener_dependency]

  network_configuration {
    subnets         = var.subnets
    security_groups = var.security_groups
    assign_public_ip = var.assign_public_ip
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.image_name
    container_port   = var.container_port
  }
}
