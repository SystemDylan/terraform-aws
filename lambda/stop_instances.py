import boto3

def lambda_handler(event, context):
    client = boto3.client('autoscaling')

    asg_names = ["asg-fortune-dynamo", "asg-fortune-SQL"]

    responses = []

    for asg_name in asg_names:
        # Set the minimum capacity of the Auto Scaling group to 0 instances
        client.update_auto_scaling_group(
            AutoScalingGroupName=asg_name,
            MinSize=0
        )

        # Set the desired capacity of the Auto Scaling group to 0 instances
        response = client.set_desired_capacity(
            AutoScalingGroupName=asg_name,
            DesiredCapacity=0,
            HonorCooldown=False
        )
        responses.append(response)

    return responses
