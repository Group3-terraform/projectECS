#######################################
# Root variables for DEV env
#######################################

variable "project_name" {
  description = "Project name (e.g., group3)"
  type        = string
}

variable "environment" {
  description = "Environment (e.g., dev, uat, prod)"
  type        = string
}

variable "region" {
  description = "AWS region (e.g., ap-southeast-1)"
  type        = string
}

#######################################
# Domain / Route53 / ACM
#######################################

variable "domain_name" {
  description = "FQDN for this environment, e.g. api.dev.theareak.click"
  type        = string
}

variable "zone_id" {
  description = "Route53 hosted zone ID for theareak.click"
  type        = string
}

#######################################
# VPC
#######################################

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_subnets" {
  description = "Public subnet CIDRs"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private subnet CIDRs"
  type        = list(string)
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
}

#######################################
# ECS service images
#######################################

variable "service_a_image" {
  description = "ECR image for service A"
  type        = string
}

variable "service_b_image" {
  description = "ECR image for service B"
  type        = string
}

variable "service_c_image" {
  description = "ECR image for service C"
  type        = string
}
