########################################
# ECS Cluster
########################################
resource "aws_ecs_cluster" "this" {
  name = "${var.project}-${var.environment}-cluster"
}

########################################
# CloudWatch Log Groups
########################################
resource "aws_cloudwatch_log_group" "service_a" {
  name              = "/ecs/${var.project}/${var.environment}/service_a"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "service_b" {
  name              = "/ecs/${var.project}/${var.environment}/service_b"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "service_c" {
  name              = "/ecs/${var.project}/${var.environment}/service_c"
  retention_in_days = 30
}

########################################
# Task Definition Template
########################################
locals {
  common_container_def = {
    cpu       = 512
    memory    = 1024
    essential = true
    portMappings = [{
      containerPort = 5000
      hostPort      = 5000
      protocol      = "tcp"
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-region        = var.region
        awslogs-stream-prefix = "ecs"
      }
    }
  }
}

########################################
# SERVICE A Task Definition
########################################
resource "aws_ecs_task_definition" "service_a" {
  family                   = "${var.project}-${var.environment}-svc-a"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = var.ecs_task_execution_role
  task_role_arn            = var.ecs_task_role

  container_definitions = jsonencode([
    merge(local.common_container_def, {
      name        = "service-a"
      image       = var.service_a_image
      environment = var.common_env
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.service_a.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "svc-a"
        }
      }
    })
  ])
}

########################################
# SERVICE B Task Definition
########################################
resource "aws_ecs_task_definition" "service_b" {
  family                   = "${var.project}-${var.environment}-svc-b"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = var.ecs_task_execution_role
  task_role_arn            = var.ecs_task_role

  container_definitions = jsonencode([
    merge(local.common_container_def, {
      name        = "service-b"
      image       = var.service_b_image
      environment = var.common_env
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.service_b.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "svc-b"
        }
      }
    })
  ])
}

########################################
# SERVICE C Task Definition
########################################
resource "aws_ecs_task_definition" "service_c" {
  family                   = "${var.project}-${var.environment}-svc-c"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = var.ecs_task_execution_role
  task_role_arn            = var.ecs_task_role

  container_definitions = jsonencode([
    merge(local.common_container_def, {
      name        = "service-c"
      image       = var.service_c_image
      environment = var.common_env
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.service_c.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "svc-c"
        }
      }
    })
  ])
}

########################################
# ECS Services
########################################

resource "aws_ecs_service" "service_a" {
  name            = "${var.project}-${var.environment}-svc-a"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.service_a.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    assign_public_ip = false
    subnets         = var.private_subnets
    security_groups = var.security_groups
  }

  load_balancer {
    target_group_arn = var.tg_service_a
    container_name   = "service-a"
    container_port   = 5000
  }

  depends_on = [var.alb_listener]
}

resource "aws_ecs_service" "service_b" {
  name            = "${var.project}-${var.environment}-svc-b"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.service_b.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    assign_public_ip = false
    subnets         = var.private_subnets
    security_groups = var.security_groups
  }

  load_balancer {
    target_group_arn = var.tg_service_b
    container_name   = "service-b"
    container_port   = 5000
  }

  depends_on = [var.alb_listener]
}

resource "aws_ecs_service" "service_c" {
  name            = "${var.project}-${var.environment}-svc-c"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.service_c.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    assign_public_ip = false
    subnets         = var.private_subnets
    security_groups = var.security_groups
  }

  load_balancer {
    target_group_arn = var.tg_service_c
    container_name   = "service-c"
    container_port   = 5000
  }

  depends_on = [var.alb_listener]
}

