terraform {
  backend "s3" {
    bucket         = "swoom-assignment-terraform-state"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "swoom-assignment-terraform-lock"
  }
}
