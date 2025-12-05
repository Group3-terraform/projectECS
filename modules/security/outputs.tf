output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}
output "ecs_sg_id" {
  value = aws_security_group.ecs_sg.id
}


output "ecs_tasks_sg_id" {
  value = aws_security_group.ecs_tasks_sg.id
}
