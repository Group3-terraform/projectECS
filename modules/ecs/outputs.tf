output "cluster_id" {
  value = aws_ecs_cluster.this.id
}

output "service_a_name" {
  value = aws_ecs_service.service_a.name
}

output "service_b_name" {
  value = aws_ecs_service.service_b.name
}

output "service_c_name" {
  value = aws_ecs_service.service_c.name
}

output "ecs_sg_id" {
  value = aws_security_group.ecs_sg.id
}
