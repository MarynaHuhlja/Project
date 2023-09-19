terraform {
  backend "s3" {
    bucket = "maryna-terraform-state"
    key    = "environment/test/rds/terraform.tfstate"
    region = "eu-central-1"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "maryna-terraform-state"
    key    = "environment/test/vpc/terraform.tfstate"
    region = "eu-central-1"
  }

}

data "aws_availability_zones" "available" {
  state = "available"
}


module "rds-postgres" {
  source                  = "git::https://github.com/cloudposse/terraform-aws-rds.git?ref=0.43.0"
  vpc_id                  = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids              = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  availability_zone       = slice(data.aws_availability_zones.available.names, 0, 1)
  host_name               = "db-postgres"
  database_name           = "rdspostgres"
  database_user           = "postgres"
  database_password       = "maryna321"
  database_port           = "5432"
  db_parameter_group      = "postgres"
  engine                  = "postgres"
  engine_version          = "14.7"
  major_engine_version    = "14"
  instance_class          = "db.t2.micro"
  backup_retention_period = "7"
  allocated_storage       = "20"
  max_allocated_storage   = "50"
}

