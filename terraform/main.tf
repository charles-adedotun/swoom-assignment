provider "aws" {
  region = "us-east-1"
}

module "network" {
  source = "./network"
  region = var.region
  prefix = var.prefix
  azs    = var.azs
}

module "iam" {
  source = "./iam"
  prefix = var.prefix
}

module "ecs" {
  source                = "./ecs"
  prefix                = var.prefix
  vpc_id                = module.network.vpc_id
  image_url             = var.image_url
  private_subnets       = module.network.private_subnets
  execution_role_arn    = module.iam.ecs_execution_role_arn
  alb_security_group_id = module.alb.alb_security_group_id
  target_group_arn      = module.alb.target_group_arn
}

module "alb" {
  source                = "./alb"
  prefix                = var.prefix
  vpc_id                = module.network.vpc_id
  public_subnets        = module.network.public_subnets
  ecs_service_name      = module.ecs.ecs_service_name
  ecs_security_group_id = module.ecs.ecs_security_group_id
}
