variable "instance_id" {
  description = "The ID of the EC2 instance to create an AMI from"
  type = string  
}

variable "name" {
  description = "The name of the AMI"
  type = string
}

variable "description" {
  description = "A description of the AMI"
  type = string
}
