resource "aws_lb" "service_alb" {
  name               = "${var.capacity}-service-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group]
  subnets            = var.subnets

}

resource "aws_lb_target_group" "alb_service_tg" {
  name        = "${var.capacity}-service-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 5
    unhealthy_threshold = 3
    timeout             = 120
    interval            = 121
    path                = "/actuator/health"
    matcher             = "200"
  }

  depends_on = [
    aws_lb.service_alb
  ]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.service_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_service_tg.arn
  }

  depends_on = [
    aws_lb_target_group.alb_service_tg
  ]
}


resource "aws_lb_listener_rule" "default_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_service_tg.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  depends_on = [
    aws_lb_listener.http
  ]
}