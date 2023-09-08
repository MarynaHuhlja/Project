terraform {
  backend "s3" {
    bucket = "maryna-terraform-state"
    key    = "environment/test/vpcmore/terraform.tfstate"
    region = "eu-central-1"
  }
}


data "aws_availability_zones" "available" {
  state = "available"
}
locals {
  region = "eu-central-1"
  name   = "test-vpc-Project"
  azs    = slice(data.aws_availability_zones.available.names, 0, 1)

  tags = {
    Name = var.name
  }
}

resource "aws_eip" "nat" {
  count  = 2
  domain = "vpc"

  tags = {
    Name = var.name
  }
}

module "vpc" {

  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = var.name
  cidr = var.vpc_cidr

  azs             = local.azs
  private_subnets = var.private_subnet_cidrs
  public_subnets  = var.public_subnet_cidrs

  enable_nat_gateway  = true
  single_nat_gateway  = false
  reuse_nat_ips       = true             # <= Skip creation of EIPs for the NAT Gateways
  external_nat_ip_ids = aws_eip.nat.*.id # <= IPs specified here as input to the module

  tags = local.tags

}
