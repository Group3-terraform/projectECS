#######################################
# Terraform + Backend
#######################################
terraform {
  required_version = ">= 1.5"
}

provider "aws" {
  region = var.region
}

#######################################
# VPC
#######################################
module "vpc" {
  source      = "../../modules/vpc"
  project     = var.project_name
  environment = var.environment
  region      = var.region
}

#######################################
# SECURITY GROUPS
#######################################
module "security" {
  source      = "../../modules/security"
  project     = var.project_name
  environment = var.environment
  vpc_id      = module.vpc.vpc_id
}

#######################################
# IAM
#######################################
module "iam" {
  source      = "../../modules/iam"
  project     = var.project_name
  environment = var.environment
}

#######################################
# ACM Certificate
#######################################
module "acm" {
  source      = "../../modules/acm"
  project     = var.project_name
  environment = var.environment
  domain      = var.domain_name
  zone_id     = var.zone_id
}

#######################################
# ALB
#######################################
module "alb" {
  source          = "../../modules/alb"
  project         = var.project_name
  environment     = var.environment
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  security_groups = [module.security.alb_sg_id]
  acm_arn         = module.acm.certificate_arn
}

#######################################
# Route53 — DNS for api.dev.theareak.click
#######################################
module "route53" {
  source      = "../../modules/route53"

  project     = var.project_name
  environment = var.environment

  domain      = var.domain_name
  zone_id     = var.zone_id

  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}

#######################################
# ECS Services
#######################################
module "ecs" {
  source      = "../../modules/ecs"

  project     = var.project_name
  environment = var.environment
  region      = var.region

  service_a_image = var.service_a_image
  service_b_image = var.service_b_image
  service_c_image = var.service_c_image

  private_subnets = module.vpc.private_subnets
  security_groups = [module.security.ecs_sg_id]

  tg_service_a = module.alb.tg_service_a_arn
  tg_service_b = module.alb.tg_service_b_arn
  tg_service_c = module.alb.tg_service_c_arn

  alb_listener = module.alb.https_listener_arn

  ecs_task_execution_role = module.iam.ecs_task_execution_role_arn
  ecs_task_role           = module.iam.ecs_task_role_arn

  common_env = [
    { name = "PROJECT",     value = var.project_name },
    { name = "ENVIRONMENT", value = var.environment }
  ]
}

#######################################
# OUTPUTS
#######################################
output "load_balancer_dns" {
  value = module.alb.alb_dns_name
}

output "api_base" {
  value = "https://${var.domain_name}"
}

output "service_a_url" {
  value = "https://${var.domain_name}/a"
}

output "service_b_url" {
  value = "https://${var.domain_name}/b"
}

output "service_c_url" {
  value = "https://${var.domain_name}/c"
}
