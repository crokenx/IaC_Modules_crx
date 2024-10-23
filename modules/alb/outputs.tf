output "alb_arn" {
  value = aws_lb.service_alb.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.alb_service_tg.arn
}
