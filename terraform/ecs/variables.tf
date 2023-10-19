variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "image_url" {
  description = "URL of the Docker image in ECR"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnets for ECS tasks"
  type        = list(string)
}

variable "execution_role_arn" {
  description = "ARN of the ECS task execution role"
  type        = string
}

variable "alb_security_group_id" {
  description = "Security Group ID of the ALB"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the ALB Target Group for front_end"
  type        = string
}
