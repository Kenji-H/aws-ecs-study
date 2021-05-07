resource "aws_lb" "lb" {
  internal = false
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.security_group.id]
  subnets = [
    aws_subnet.subnet_1.id,
    aws_subnet.subnet_2.id]

  tags = {
    Project = var.project_name
  }
}

resource "aws_lb_target_group" "lb_target_group" {
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.vpc.id

  tags = {
    Project = var.project_name
  }
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.lb.id
  port = "80"
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.lb_target_group.id
    type = "forward"
  }
}
