data "aws_ami" "ec2web" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "block-device-mapping.snapshot-id"
    values = ["${var.snapshot_id}"]
  }
}

resource "aws_instance" "ec2web" {
  ami           = "${var.ami_id}"
  instance_type = "t2.micro"
  vpc_security_group_ids = [
    var.security_group_id,
  ]
  tags = {
    Name = "ec2_web"
  }
}

output "ec2web_public_ip" {
  value = aws_instance.ec2web.public_ip
}

