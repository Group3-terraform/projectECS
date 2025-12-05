###############################################
# Application Load Balancer (Public)
###############################################

resource "aws_lb" "api" {
  name               = "${var.project}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.public_subnets

  enable_deletion_protection = false
}

###############################################
# ALB Target Groups (Service A, B, C)
###############################################

resource "aws_lb_target_group" "service_a" {
  name     = "${var.project}-${var.environment}-svc-a"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/health"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 15
  }
}

resource "aws_lb_target_group" "service_b" {
  name     = "${var.project}-${var.environment}-svc-b"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/health"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 15
  }
}

resource "aws_lb_target_group" "service_c" {
  name     = "${var.project}-${var.environment}-svc-c"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/health"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 15
  }
}

###############################################
# Listener: HTTP (80) → Redirect to HTTPS (443)
###############################################

resource "aws_lb_listener" "https_redirect" {
  load_balancer_arn = aws_lb.api.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      protocol   = "HTTPS"
      port       = "443"
      status_code = "HTTP_301"
    }
  }
}

###############################################
# Listener: HTTPS (443)
###############################################

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.api.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}

###############################################
# Routing rules for /a, /b, /c
###############################################

resource "aws_lb_listener_rule" "route_a" {
  listener_arn = aws_lb_listener.https.arn

  priority = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_a.arn
  }

  condition {
    path_pattern {
      values = ["/a/*", "/a"]
    }
  }
}

resource "aws_lb_listener_rule" "route_b" {
  listener_arn = aws_lb_listener.https.arn

  priority = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_b.arn
  }

  condition {
    path_pattern {
      values = ["/b/*", "/b"]
    }
  }
}

resource "aws_lb_listener_rule" "route_c" {
  listener_arn = aws_lb_listener.https.arn

  priority = 30

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_c.arn
  }

  condition {
    path_pattern {
      values = ["/c/*", "/c"]
    }
  }
}

