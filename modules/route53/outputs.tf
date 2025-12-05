output "api_domain" {
  value = "api.${var.environment}.${var.domain_name}"
}

output "route53_record_fqdn" {
  value = aws_route53_record.api_alias.fqdn
}
