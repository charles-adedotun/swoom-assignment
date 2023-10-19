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
