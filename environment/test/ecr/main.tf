#### remore state ###
terraform {
  backend "s3" {
    bucket = "maryna-terraform-state"
    key    = "environment/test/ecr/terraform.tfstate"
    region = "eu-central-1"
  }
}

### Global variamles ###
data "terraform_remote_state" "global" {
  backend = "s3"
  config = {
    bucket = "maryna-terraform-state"
    key    = "global/terraform.tfstate"
    region = "eu-central-1"
  }
}

locals {
  company_name = data.terraform_remote_state.global.outputs.company_name
  owner        = data.terraform_remote_state.global.outputs.owner
  common_tags  = data.terraform_remote_state.global.outputs.tags
}
#### Module ECR ####

#source          = "git::https://github.com/terraform-aws-modules/terraform-aws-ecr.git?ref=v1.6.0"
data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "project-test"
  #repository_read_write_access_arns = ["arn:aws:iam::012345678901:role/terraform"]
  repository_read_write_access_arns = [data.aws_caller_identity.current.arn]
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = {
    Terraform   = "true"
    Environment = "test"
  }
}

#####
