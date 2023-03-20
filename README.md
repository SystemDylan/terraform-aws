# Terraform AWS

A collection of Terraform templates for deploying various AWS resources.
Python and Shell scripting are used for environment management where Terraform cannot.

This repository contains Terraform configuration examples for:

- Creating a base EC2 instance from a premade Linux AMI (ec2/ec2.tf) and a custom AMI based on an EBS snapshot (ec2/ec2_ami_restore.tf). The custom AMI includes a basic Apache web server for easy web development testing.
- Setting up an AWS Virtual Private Cloud (VPC) with two subnets in separate availability zones, one route table connected to an internet gateway, and configured associations for both subnets to that gateway (vpc/vpc.tf).
- A reusable module for creating an AMI image from any existing EC2 instance (aws-ami/main.tf).
- Configuring an Auto Scaling group with an Elastic Load Balancer, Simple Scaling policy, a minimum of 2 instances across two different availability zones, and a maximum of 4 instances (elb/main.tf).
- Creating a basic DynamoDB table with a composite key and provisioned read/write capacity (dynamodb/dynamodb.tf).

## Submodule: Fortune of the Day Application

This repository includes a submodule containing the source code for a sample application that utilizes the above AWS resources and Terraform configurations. The submodule can be found at the following URL:

[Fortune of the Day Submodule](https://github.com/SystemDylan/fortune-of-the-day)

You can visit the live web app at:

[Fortune of the Day Web App](https://fortune.systemdylan.com/)

Fortune of the Day Web App reworked to use a VPN connection to a local DB instead of Amazon DynamoDB:

[SQL Fortunne of the Day Web App](https://sqlfortune.systemdylan.com/)

Repo Containing Terraform management config and python DB management scripts for the SQL Fortune of the Day Rework:

[terraform-proxmox](https://github.com/SystemDylan/terraform-proxmox)

## Future Additions

- More Terraform configurations and use cases to be added
