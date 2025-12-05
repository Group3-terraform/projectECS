terraform {
  backend "s3" {
    bucket         = "group3-tfstate-dev"
    key            = "ecs/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "group3-tfstate-lock"
  }
}

provider "aws" {
  region = var.region
}

# ----------------------
# VPC
# ----------------------
module "vpc" {
  source        = "../../modules/vpc"
  project_name  = var.project_name
  environment   = var.environment
  region        = var.region
}

# ----------------------
# SECURITY
# ----------------------
module "security" {
  source       = "../../modules/security"
  vpc_id       = module.vpc.vpc_id
  project_name = var.project_name
  environment  = var.environment
}

# ----------------------
# ACM Certificate
# ----------------------
module "acm" {
  source       = "../../modules/acm"
  project_name = var.project_name
  environment  = var.environment
  domain       = var.domain
  zone_id      = var.zone_id
}

# ----------------------
# ALB
# ----------------------
module "alb" {
  source          = "../../modules/alb"
  project_name    = var.project_name
  environment     = var.environment
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  security_groups = [module.security.alb_sg_id]
  acm_arn         = module.acm.certificate_arn
}

# ----------------------
# IAM
# ----------------------
module "iam" {
  source        = "../../modules/iam"
  project_name = var.project_name
  environment  = var.environment
}

# ----------------------
# ECS
# ----------------------
module "ecs" {
  source              = "../../modules/ecs"
  project_name        = var.project_name
  environment         = var.environment
  vpc_id              = module.vpc.vpc_id
  private_subnets     = module.vpc.private_subnets
  alb_listener_arn    = module.alb.https_listener_arn
  task_execution_role = module.iam.ecs_task_execution_role_arn
  task_role           = module.iam.ecs_task_role_arn

  service_a_image = var.service_a_image
  service_b_image = var.service_b_image
  service_c_image = var.service_c_image
}

# ----------------------
# Route 53
# ----------------------
module "route53" {
  source       = "../../modules/route53"
  project_name = var.project_name
  environment  = var.environment
  domain       = var.domain
  zone_id      = var.zone_id
  alb_dns_name = module.alb.dns_name
  alb_zone_id  = module.alb.zone_id
}

# ----------------------
# OUTPUTS
# ----------------------
output "alb_url"     { value = "https://${var.domain}" }
output "service_a"   { value = "https://${var.domain}/a" }
output "service_b"   { value = "https://${var.domain}/b" }
output "service_c"   { value = "https://${var.domain}/c" }
