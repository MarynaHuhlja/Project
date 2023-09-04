## 1 vpc +1 Internat Gateway + 2 public subnets + 2 private subnets + 2 NAT Gateway + 
provider "aws" {
  shared_config_files      = ["$HOME/.aws/config"]
  shared_credentials_files = ["$HOME/.aws/credentials"]
}

module "vpc_dev" {
  source               = "../modules"
  env                  = var.env
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

########################

output "dev_public_subnet_ids" {
  value = module.vpc_dev.public_subnet_ids

}

output "dev_private_subnet_ids" {
  value = module.vpc_dev.private_subnet_ids

}
