# terraform-aws
Terraform setup templates to deploy various resources on aws

This repo contains Terraform configuration examples for the following:

-Spinning up a base EC2 instance from a premade linux AMI(ec2/ec2.tf) and a custom AMI based off an EBS snapshot(ec2/ec2_ami_restore.tf). The custom AMI has a basic apache webserver installed and listening for easy web dev testing.

-Creating aws Virtual Private Cloud with two subnets on separate availability zones, one route table with a connection to an internet gateway, and configurated associations from both subnets to that gateway(vpc/vpc.tf).

-A reusable module that can be used to create an AMI image from any existing EC2 instance(aws-ami/main.tf).

-Terraform configuration example for a an autoscaling group with an elastic load balancer configured with SimpleScaling, a minimum of 2 instances on two different availability zones, and a maximum of 4 instances(elb/main.tf).

-Creating a basic Dynamodb with a composite key and provisioned read / write capacity(dynamodb/dynamodb.tf).


-more to come!
