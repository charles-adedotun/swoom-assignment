provider "aws" {
  region = var.region
}

module "network" {
  source = "./network"
  region = var.region
  prefix = var.prefix
  azs    = var.azs
}
