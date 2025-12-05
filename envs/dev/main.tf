########################################
# Load modules
########################################

module "alb" {
  source       = "../../modules/alb"
  project_name = var.project_name
  environment  = var.environment

  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets

  security_groups = [module.security.alb_sg_id]

  acm_arn = module.acm.acm_arn
}


module "security" {
  source       = "../../modules/security"
  vpc_id       = module.vpc.vpc_id
  project_name = var.project_name
  environment  = var.environment
}


module "iam" {
  source       = "../../modules/iam"
  project_name = var.project_name
  environment  = var.environment
}

module "acm" {
  source       = "../../modules/acm"
  project_name = var.project_name
  environment  = var.environment

  # Single domain for DEV
  domain       = "api.dev.theareak.click"

  # Your Route53 Hosted Zone ID
  zone_id      = "Z07852252OWMU8O090PPL"
}


# module "alb" {
#   source       = "../../modules/alb"
#   project_name = var.project_name
#   environment  = var.environment

#   vpc_id         = module.vpc.vpc_id
#   public_subnets = module.vpc.public_subnets

#   security_groups = [module.security.alb_sg_id]

#   acm_arn = module.acm.acm_arn
# }


module "route53" {
  source       = "../../modules/route53"
  project_name = var.project_name
  environment  = var.environment

  domain       = var.domain_name

  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id

  zone_id      = var.zone_id
}


module "ecs" {
  source               = "../../modules/ecs"
  project              = var.project
  environment          = var.environment
  region               = var.region

  service_a_image = var.service_a_image
  service_b_image = var.service_b_image
  service_c_image = var.service_c_image

  private_subnets = module.vpc.private_subnets
  security_groups = [module.security.ecs_sg_id]

  tg_service_a = module.alb.tg_service_a
  tg_service_b = module.alb.tg_service_b
  tg_service_c = module.alb.tg_service_c

  alb_listener = module.alb.https_listener_arn

  ecs_task_role           = module.iam.ecs_task_role
  ecs_task_execution_role = module.iam.ecs_task_execution_role

  common_env = [
    { name = "ENV",        value = var.environment },
    { name = "PROJECT",    value = var.project },
    { name = "REGION",     value = var.region }
  ]
}

########################################
# OUTPUTS
########################################

output "alb_url" {
  value = module.alb.alb_dns
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
