module "my_ami" {
  source      = "./aws-ami"
  instance_id = var.instance_id
  name        = var.name
  description = var.description
}
