# Create the autoscaling group
resource "aws_autoscaling_group" "asg1" {
  name = "asg1"
  launch_template {id = aws_launch_template.asg1-lt.id}
  vpc_zone_identifier = [
    var.subnet1,
    var.subnet2
  ]
  target_group_arns = [aws_lb_target_group.asg1-tg.arn]

  # Define the autoscaling group settings
  min_size = 2
  max_size = 4
  desired_capacity = 2

  # Define the health check settings
  health_check_type = "ELB"
  health_check_grace_period = 300
}
  # Create the scaling policies
resource "aws_autoscaling_policy" "scale-up1" {
  name = "scale-up1"
  policy_type = "SimpleScaling"
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = 1
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.asg1.name
}

resource "aws_autoscaling_policy" "scale-down1" {
  name = "scale-down1"
  policy_type = "SimpleScaling"
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = -1
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.asg1.name
}

# Create the launch template
resource "aws_launch_template" "asg1-lt" {
  name = "asg1-lt"
  image_id = var.custom_ami_id
  instance_type = "t2.micro"
  key_name = var.keyname
  vpc_security_group_ids = [var.security_group1_id]
}

# Create the target group
resource "aws_lb_target_group" "asg1-tg" {
  name = "asg1-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
}

# Create the load balancer
resource "aws_lb" "asg1-lb" {
  name = "asg1-lb"
  subnets = [
    var.subnet1,
    var.subnet2
  ]
  security_groups = [var.security_group1_id]
}
# Define the listener settings
resource "aws_lb_listener" "asg1-lb-listener" {
  load_balancer_arn = aws_lb.asg1-lb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.asg1-tg.arn
  }
}
# Create the load balancer security group
resource "aws_security_group" "asg1-lb-sg" {
  name = "asg1-lb-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

