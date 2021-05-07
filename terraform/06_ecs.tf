resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.project_name}_cluster"
  capacity_providers = [
    aws_ecs_capacity_provider.ecs_capacity_provider.name]
  default_capacity_provider_strategy {
    base = 0
    capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
    weight = 1
  }
}

resource "aws_ecs_capacity_provider" "ecs_capacity_provider" {
  name = "default_capacity_provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.asg.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      status = "ENABLED"
      target_capacity = 100
    }
  }
}

resource "aws_ecs_service" "ecs_service" {
  name = "${var.project_name}-service"
  task_definition = aws_ecs_task_definition.task_definition.arn
  cluster = aws_ecs_cluster.ecs_cluster.arn
  desired_count = 1

  iam_role = aws_iam_role.ecs_service_role.arn

  load_balancer {
    target_group_arn = aws_lb_target_group.lb_target_group.id
    container_name = "nginx"
    container_port = 80
  }

  depends_on = [
    aws_lb_listener.lb_listener
  ]

  lifecycle {
    ignore_changes = [
      desired_count]
  }
}

resource "aws_ecs_task_definition" "task_definition" {
  container_definitions = file("./templatefile/task-definition.json")
  family = "test-task"
  cpu = "256"
  memory = "256"
  requires_compatibilities = [
    "EC2"]
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity = 5
  min_capacity = 1
  role_arn = aws_iam_role.ecs_autoscaling_role.arn
  resource_id = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy" {
  name = "ecs-policy"
  policy_type = "TargetTrackingScaling"
  resource_id = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 70
    scale_in_cooldown = 60
    scale_out_cooldown = 60
  }
}