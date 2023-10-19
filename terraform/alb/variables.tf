variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnets for ALB"
  type        = list(string)
}

variable "ecs_service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "ecs_security_group_id" {
  description = "ID of the ECS security group"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}
