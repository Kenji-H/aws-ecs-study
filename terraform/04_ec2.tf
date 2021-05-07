resource "aws_autoscaling_group" "asg" {
  vpc_zone_identifier = [
    aws_subnet.subnet_1.id,
    aws_subnet.subnet_2.id]
  desired_capacity = 0
  max_size = 5
  min_size = 0
  launch_template {
    id = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  health_check_type = "EC2"
  health_check_grace_period = 300
  protect_from_scale_in = true

  tag {
    key = "AmazonECSManaged"
    value = ""
    propagate_at_launch = true
  }
  tag {
    key = "Project"
    value = var.project_name
    propagate_at_launch = true
  }
}

resource "aws_launch_template" "launch_template" {
  image_id = var.ami
  instance_type = "t2.medium"
  vpc_security_group_ids = [
    aws_security_group.security_group.id]

  user_data = base64encode(templatefile("./templatefile/userdata.sh",
  {
    cluster_name = "${var.project_name}_cluster"
  }))

  key_name = var.ssh_key_name

  iam_instance_profile {
    arn = aws_iam_instance_profile.ecs_instance_role.arn
  }
}