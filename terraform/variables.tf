variable "region" {
  description = "The AWS region"
  default     = "us-east-1"
}

variable "prefix" {
  description = "Prefix for resource names"
  default     = "swoom-assignment-"
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "image_url" {
  description = "URL of the Docker image in ECR"
  type        = string
  default     = "433826697239.dkr.ecr.us-east-1.amazonaws.com/swoom-assignment-app-repo:30"
}
