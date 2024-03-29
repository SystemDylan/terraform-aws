# Create the autoscaling group
resource "aws_autoscaling_group" "asg-fortune-SQL" {
  name = "asg-fortune-SQL"
  launch_template {id = aws_launch_template.fortune-SQL-lt.id}
  vpc_zone_identifier = [
    var.subnet1,
    var.subnet2
  ]
  target_group_arns = [aws_lb_target_group.fortune-SQL-tg.arn]

  # Define the autoscaling group settings
  min_size = 2
  max_size = 4
  desired_capacity = 2

  # Define the health check settings
  health_check_type = "EC2"
  health_check_grace_period = 300
}
  # Create the scaling policies
resource "aws_autoscaling_policy" "scale-up1" {
  name = "scale-up1"
  policy_type = "SimpleScaling"
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = 1
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.asg-fortune-SQL.name
}
resource "aws_autoscaling_policy" "scale-down1" {
  name = "scale-down1"
  policy_type = "SimpleScaling"
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = -1
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.asg-fortune-SQL.name
}

# Create the launch template
resource "aws_launch_template" "fortune-SQL-lt" {
  name = "fortune-SQL-lt"
  image_id = var.fortune_SQL_ami
  instance_type = "t2.micro"
  key_name = var.keyname
  vpc_security_group_ids = [var.security_group1_id]
#tag specifications to add names to the asg instances
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "fortune-SQL-instance"
    }
  }
}

# Create the target group - the target group contains the flask app which is listening on port 5000
resource "aws_lb_target_group" "fortune-SQL-tg" {
  name = "fortune-SQL-tg"
  port = 5000
  protocol = "HTTP"
  vpc_id = var.vpc_id
}

# Create the load balancer
resource "aws_lb" "fortune-SQL-lb" {
  name = "fortune-SQL-lb"
  subnets = [
    var.subnet1,
    var.subnet2
  ]
  security_groups = [var.security_group1_id]
}
# Define the listener settings - Receives traffic on port 443 and then sends to the target group, which is listening on port 5000. Certificate_arn must be specified when using https
resource "aws_lb_listener" "fortune_SQL_lb_listener" {
  load_balancer_arn = aws_lb.fortune-SQL-lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fortune-SQL-tg.arn
  }
}
# Define a second listener for port 80 with a redirect action to port 443
resource "aws_lb_listener" "fortune_SQL_lb_listener_redirect" {
  load_balancer_arn = aws_lb.fortune-SQL-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301" #output status code 301 if port 80 is visited
    }
  }
}
#Create a CNAME DNS record and assign point to the DNS name of the elastic load balancer
resource "aws_route53_record" "app_cname" {
  zone_id = var.dns_zone_id
  name    = var.fortune_SQL_DNS
  type    = "CNAME"
  ttl     = "300"
  records = [aws_lb.fortune-SQL-lb.dns_name]
}

# Associate the SSL certificate with the Load Balancer Listener for the fortune-SQL application
resource "aws_lb_listener_certificate" "fortune_SQL_lb_listener_certificate" {
  listener_arn    = aws_lb_listener.fortune_SQL_lb_listener.arn # The ARN of the Load Balancer Listener for the fortune-SQL application
  certificate_arn = var.certificate_arn                          # The ARN of the SSL certificate to be associated with the Load Balancer Listener
}

# Output the ARN of the created fortune-SQL load balancer
output "load_balancer_arn" {
  description = "The ARN of the created fortune-dynamo load balancer"
  value       = aws_lb.fortune-SQL-lb.arn # The ARN of the created fortune-SQL load balancer
}

