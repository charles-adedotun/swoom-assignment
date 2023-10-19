variable "region" {
  description = "The AWS region"
  type        = string
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}
