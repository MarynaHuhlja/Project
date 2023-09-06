module "my_ecr" {
  source           = "./my-ecr-module"
  repository_name  = "my-container-repo"
  lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority    = 1,
        description     = "Keep last 30 images",
        selection       = {
          tagStatus    = "untagged",
          countType    = "sinceImagePushed",
          countNumber  = 30,
          countUnit    = "days",
        },
        action          = {
          type = "expire"
        }
      }
    ]
  })
}
