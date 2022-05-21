# ELB
resource "aws_lb" "alb" {
  name                       = "${var.prefix}-alb"
  load_balancer_type         = "application"
  internal                   = false
  idle_timeout               = 3000
  enable_deletion_protection = false

  subnets = [
    aws_subnet.public_subnet_1a.id,
    aws_subnet.public_subnet_1c.id
  ]

  security_groups = [
    aws_security_group.elb_sg.id
  ]
}
# Target group
resource "aws_lb_target_group" "alb_tg" {
  name                 = "${var.prefix}-alb-tg"
  target_type          = "instance"
  vpc_id               = aws_vpc.vpc.id
  port                 = 80
  protocol             = "HTTP"

  health_check {
    protocol            = "HTTP"
    path                = "/"
  }
}

resource "aws_lb_target_group_attachment" "alb_tg" {
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = aws_instance.web_01.id
  port             = 80
}

# Listener
resource "aws_alb_listener" "alb" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${ aws_lb_target_group.alb_tg.arn}"
    type             = "forward"
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.public.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

# Route53 (Alias record)
resource "aws_route53_record" "alb" {
  name    = "www.${aws_route53_zone.public.name}"
  zone_id = aws_route53_zone.public.zone_id
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}
