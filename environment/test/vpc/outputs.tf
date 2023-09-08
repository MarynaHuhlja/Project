output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr" {
  value = module.vpc.vpc_cidr_block

}

output "public_subnet_ids" {
  value = module.vpc.public_subnets_ipv6_cidr_blocks

}

output "private_subnet_ids" {
  value = module.vpc.private_subnets
}

output "default_route_table_tag" {
  value = var.default_route_table_tags
}

output "default_security_group_name" {
  value = var.default_security_group_name
}
