variable "zone_id" {
  type        = string
  description = "Route53 Hosted Zone ID (Zxxxxxxxxx)"
}

variable "domain" {
  type        = string
  description = "Base domain, example: theareak.click"
}

variable "environment" {
  type        = string
  description = "dev / uat / sit / prod"
}

variable "alb_dns_name" {
  type        = string
  description = "DNS name of the ALB"
}

variable "alb_zone_id" {
  type        = string
  description = "Route53 zone ID of the ALB"
}


variable "project_name" { type = string }

variable "domain"       { type = string }

