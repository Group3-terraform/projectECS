variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "domain" {
  type = string
  description = "Base domain name (example: theareak.click)"
}

variable "zone_id" {
  type = string
  description = "Route53 Hosted Zone ID"
}
