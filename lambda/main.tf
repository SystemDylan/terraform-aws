# Create an IAM role for the Lambda functions
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  # Define the trust policy allowing Lambda service to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach a policy to the IAM role, allowing the required autoscaling actions
resource "aws_iam_role_policy" "lambda_ec2_scaling_policy" {
  name = "lambda_ec2_scaling_policy"
  role = aws_iam_role.lambda_role.id
  
# Define the policy allowing DescribeAutoScalingGroups and SetDesiredCapacity actions
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:UpdateAutoScalingGroup"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# Create the Lambda function to start instances
resource "aws_lambda_function" "start_instances" {
  function_name = "startInstances"
  handler       = "start_instances.lambda_handler"
  runtime       = "python3.8"
  role          = aws_iam_role.lambda_role.arn
  filename      = "./start_lambda.zip"
}

# Create the Lambda function to stop instances
resource "aws_lambda_function" "stop_instances" {
  function_name = "stopInstances"
  handler       = "stop_instances.lambda_handler"
  runtime       = "python3.8"
  role          = aws_iam_role.lambda_role.arn
  filename      = "./stop_lambda.zip"
}

# Grant CloudWatch Events permission to invoke the start_instances Lambda function
resource "aws_lambda_permission" "start_instances" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.start_instances.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.start_instances.arn
}

# Grant CloudWatch Events permission to invoke the stop_instances Lambda function
resource "aws_lambda_permission" "stop_instances" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.stop_instances.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.stop_instances.arn
}

# Create a CloudWatch Event rule to trigger start_instances Lambda function at 7 AM EST, Monday through Friday
resource "aws_cloudwatch_event_rule" "start_instances" {
  name                = "start_instances"
  description         = "Start instances at 8 AM EST, Monday through Friday"
  schedule_expression = "cron(0 13 ? * MON-FRI *)"
}

# Create a CloudWatch Event rule to trigger stop_instances Lambda function at 5 PM EST, Monday through Friday
resource "aws_cloudwatch_event_rule" "stop_instances" {
  name                = "stop_instances"
  description         = "Stop instances at 6 PM EST, Monday through Friday"
  schedule_expression = "cron(0 23 ? * MON-FRI *)"
}

# Create a CloudWatch Event target for the start_instances rule to invoke the startInstances Lambda function
resource "aws_cloudwatch_event_target" "start_instances" {
  rule      = aws_cloudwatch_event_rule.start_instances.name
  target_id = "startInstances"
  arn       = aws_lambda_function.start_instances.arn
}

# Create a CloudWatch Event target for the stop_instances rule to invoke the stopInstances Lambda function
resource "aws_cloudwatch_event_target" "stop_instances" {
  rule      = aws_cloudwatch_event_rule.stop_instances.name
  target_id = "stopInstances"
  arn       = aws_lambda_function.stop_instances.arn
}

