resource "aws_ami_from_instance" "my_ami" {
  name                = var.name
  description         = var.description
  source_instance_id  = var.instance_id
}
