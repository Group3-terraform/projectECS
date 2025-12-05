##############################
# Application Load Balancer
##############################
resource "aws_lb" "alb" {
  name               = "${var.project_name}-${var.environment}-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = var.security_groups
  subnets            = var.public_subnets

  enable_deletion_protection = false

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

##############################
# TARGET GROUPS (A / B / C)
##############################
resource "aws_lb_target_group" "service_a" {
  name        = "${var.project_name}-${var.environment}-tg-a"
  port        = 5000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

resource "aws_lb_target_group" "service_b" {
  name        = "${var.project_name}-${var.environment}-tg-b"
  port        = 5000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

resource "aws_lb_target_group" "service_c" {
  name        = "${var.project_name}-${var.environment}-tg-c"
  port        = 5000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

##############################
# HTTPS LISTENER (443)
##############################
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.acm_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_a.arn
  }
}

##############################
# PATH RULES (a,b,c)
##############################
resource "aws_lb_listener_rule" "service_a" {
  listener_arn = aws_lb_listener.https.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_a.arn
  }

  condition {
    path_pattern {
      values = ["/a*"]
    }
  }
}

resource "aws_lb_listener_rule" "service_b" {
  listener_arn = aws_lb_listener.https.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_b.arn
  }

  condition {
    path_pattern {
      values = ["/b*"]
    }
  }
}

resource "aws_lb_listener_rule" "service_c" {
  listener_arn = aws_lb_listener.https.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_c.arn
  }

  condition {
    path_pattern {
      values = ["/c*"]
    }
  }
}

##############################
# OUTPUTS
##############################
output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "alb_zone_id" {
  value = aws_lb.alb.zone_id
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

output "https_listener_arn" {
  value = aws_lb_listener.https.arn
}
