output "vpc_id" {
  value = module.vpc_test.vpc_id
}

output "vpc_cidr" {
  value = module.vpc_test.vpc_cidr

}

output "public_subnet_ids" {
  value = module.vpc_test.public_subnet_ids

}

output "private_subnet_ids" {
  value = module.vpc_test.private_subnet_ids
}
