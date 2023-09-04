## 1 vpc +1 Internat Gateway + 2 public subnets + 2 private subnets + 2 NAT Gateway + 
provider "aws" {
  shared_config_files      = ["$HOME/.aws/config"]
  shared_credentials_files = ["$HOME/.aws/credentials"]
}

module "vpc_dev" {
  source               = "../modules/aws_network"
  env                  = "development"
  vpc_cidr             = "10.100.0.0/16"
  public_subnet_cidrs  = ["10.100.1.0/24", "10.100.2.0/24"]
  private_subnet_cidrs = ["10.100.11.0/24", "10.100.22.0/24"]
}

########################

output "dev_public_subnet_ids" {
  value = module.vpc_dev.public_subnet_ids

}

output "dev_private_subnet_ids" {
  value = module.vpc_dev.private_subnet_ids

}
