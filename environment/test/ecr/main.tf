module "my_ecr" {
  source          = "../../../modules/ecr"
  repository_name = "project-test"
  lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus   = "untagged",
          countType   = "sinceImagePushed",
          countNumber = 30,
          countUnit   = "days",
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
}
