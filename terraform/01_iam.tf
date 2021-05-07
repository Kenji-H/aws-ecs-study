#######################################
# IAM Role for EC2
#######################################
resource "aws_iam_role" "ecs_instance_role" {
  name = "ecs_instance_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
    Project = var.project_name
  }
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  role = aws_iam_role.ecs_instance_role.name
}

resource "aws_iam_instance_profile" "ecs_instance_role" {
  role = aws_iam_role.ecs_instance_role.name
}

#######################################
# IAM Role for ECS Service
#######################################
resource "aws_iam_role" "ecs_service_role" {
  name = "ecs_service_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
    Project = var.project_name
  }
}

resource "aws_iam_policy_attachment" "ecs_service_role" {
  name = "ecs_service_role"
  roles = [
    aws_iam_role.ecs_service_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

#######################################
# IAM Role for ECS Autoscaling
#######################################
resource "aws_iam_role" "ecs_autoscaling_role" {
  name = "ecs_autoscaling_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "application-autoscaling.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
    Project = var.project_name
  }
}

resource "aws_iam_policy_attachment" "ecs_autoscaling_role" {
  name = "ecs_autoscaling_role"
  roles = [
    aws_iam_role.ecs_autoscaling_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
}
