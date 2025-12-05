output "alb_dns_name" {
  value = aws_lb.api.dns_name
}

output "alb_zone_id" {
  value = aws_lb.api.zone_id
}

output "tg_service_a_arn" {
  value = aws_lb_target_group.service_a.arn
}

output "tg_service_b_arn" {
  value = aws_lb_target_group.service_b.arn
}

output "tg_service_c_arn" {
  value = aws_lb_target_group.service_c.arn
}
