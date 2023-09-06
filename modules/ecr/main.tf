resource "aws_ecr_repository" "my_ecr_repo" {
  name = var.repository_name
}

resource "aws_ecr_lifecycle_policy" "my_ecr_lifecycle_policy" {
  repository = aws_ecr_repository.my_ecr_repo.name
  policy     = var.lifecycle_policy
}

