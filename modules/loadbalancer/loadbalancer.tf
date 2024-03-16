resource "aws_alb" "application_load_balancer" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnet_ec2_ids
  security_groups    = var.loadbalancer_security_group_ids

  tags = {
    Name = "impact-service-alb"
  }
}

resource "aws_lb_target_group" "target_group" {
  name        = "${var.project_name}-alb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_main_id

  tags = {
    Name = "${var.project_name}-service-alb-tg"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.application_load_balancer.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.id
  }
}