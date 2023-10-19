output "vpc_id" {
  description = "ID of the VPC"
  value       = module.network.vpc_id
}

output "public_subnets" {
  description = "IDs of the public subnets"
  value       = module.network.public_subnets
}

output "private_subnets" {
  description = "IDs of the private subnets"
  value       = module.network.private_subnets
}
