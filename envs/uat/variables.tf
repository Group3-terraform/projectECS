variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "domain" {
  type = string
}

variable "zone_id" {
  type = string
}

variable "service_a_image" {
  type = string
}

variable "service_b_image" {
  type = string
}

variable "service_c_image" {
  type = string
}

variable "vpc_cidr" {}
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "azs" { type = list(string) }

variable "domain_name" {
  type = string
  description = "Full domain such as api.uat.theareak.click"
}
