resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-ecs-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "codebuild.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_attach_policy" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser" # Access to ECR
}

resource "aws_iam_role_policy_attachment" "codebuild_attach_cw_policy" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess" # CloudWatch Logs access
}

resource "aws_iam_role_policy_attachment" "codebuild_attach_s3_policy" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess" # Access to S3
}

resource "aws_iam_role_policy_attachment" "codebuild_attach_ecs_policy" {
  role = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

resource "aws_codebuild_project" "ecs_project" {
  name          = "ecs-codebuild-project"
  description   = "CodeBuild project for ECS"
  build_timeout = 30

  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0"
    type                        = "LINUX_CONTAINER"
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = "us-east-1" 
    }
  }

  source {
    type      = "GITHUB" 
    location  = "https://github.com/YashPradhan77/ECS-Terraform" 
  }
  
  source_version = "main"
}
