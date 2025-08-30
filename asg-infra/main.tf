locals {
  tag_name = "${var.tag_prefix}-${var.launch_template_name}"
}

resource "aws_security_group" "launch_template_sg" {
  name_prefix = "${var.launch_template_name}-sg"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH access"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${local.tag_name}-sg"
  }
}

resource "aws_launch_template" "main" {
  name_prefix   = var.launch_template_name
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  description = "v1"

  vpc_security_group_ids = [aws_security_group.launch_template_sg.id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${local.tag_name}-instance"
    }
  }

  tags = {
    Name        = "${local.tag_name}"
  }
}

resource "aws_autoscaling_group" "main" {
  name                = "${local.tag_name}-asg"
  vpc_zone_identifier = data.aws_subnets.default.ids
  min_size            = 2
  max_size            = 4
  desired_capacity    = 2
  health_check_grace_period = var.health_check_grace_period

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${local.tag_name}-asg"
    propagate_at_launch = false
  }
}

