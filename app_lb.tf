
resource "aws_lb" "app_lb" {
  name                             = "app-lb"
  internal                         = false
  load_balancer_type               = "application"
  security_groups                  = [aws_security_group.app_sg.id]
  subnets                          = [aws_subnet.priv1.id, aws_subnet.priv2.id]
  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true
}

resource "aws_lb_target_group" "lb-target-app" {
  name     = "lb-target-app"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.web-app-vpc.id

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_target_group_attachment" "app_tg_attachmentA" {
  target_group_arn = aws_lb_target_group.lb-target-app.arn
  target_id        = aws_instance.app_Server1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "app_tg_attachmentB" {
  target_group_arn = aws_lb_target_group.lb-target-app.arn
  target_id        = aws_instance.app_Server2.id
  port             = 80
}

resource "aws_lb_listener" "lb-listener-app" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb-target-app.arn
  }
}