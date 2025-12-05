output "certificate_arn" {
  value = aws_acm_certificate.api_cert.arn
}

output "certificate_validation_arn" {
  value = aws_acm_certificate_validation.api_cert_validation.id
}
