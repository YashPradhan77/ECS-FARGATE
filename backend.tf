# terraform {
#   backend "s3" {
#     bucket         = "ecs-terraform-state-files"
#     key            = "terraform/state"
#     dynamodb_table = "terraform-state-lock-dynamo"
#     region         = "us-east-1"
#     encrypt        = true
#     acl            = "bucket-owner-full-control"
#   }
# }

