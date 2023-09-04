
output "test_vpc_id" {
  value = aws_vpc.main.id
}

output "test_vpc_cidr" {
  value = aws_vpc.main.cidr_block

}

output "test_public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id

}

output "test_private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}
