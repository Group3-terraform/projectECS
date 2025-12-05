variable "security_groups" { type = list(string) }
variable "acm_arn" { type = string }
variable "vpc_id" { type = string }
variable "public_subnets" { type = list(string) }
variable "project_name" { type = string }
variable "environment" { type = string }
