import boto3  # Import the boto3 library to interact with AWS services

def lambda_handler(event, context):
    client = boto3.client('autoscaling')  # Create an Auto Scaling client

    # List of Auto Scaling group names
    asg_names = ["asg-fortune-dynamo", "asg-fortune-SQL"]
    
    responses = []  # Initialize an empty list to store responses from the set_desired_capacity calls
    
    # Loop through each Auto Scaling group name in the list
    for asg_name in asg_names:
        
        # Set the minimum capacity of the Auto Scaling group to 2 instances
        client.update_auto_scaling_group(
            AutoScalingGroupName=asg_name,
            MinSize=2
        ) 
       
        # Set the desired capacity of the Auto Scaling group to 2 instances
        response = client.set_desired_capacity(
            AutoScalingGroupName=asg_name,
            DesiredCapacity=2,
            HonorCooldown=False
        )
        responses.append(response)  # Add the response to the responses list

    return responses  # Return the list of responses
