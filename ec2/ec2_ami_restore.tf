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
  ami           = "${var.custom_ami_id}"
  instance_type = "t2.micro"
  subnet_id = var.subnet2_id
  vpc_security_group_ids = [
    var.security_group1_id,
  ]
  tags = {
    Name = "ec2_web"
  }

user_data = <<-EOF
              #!/bin/bash
              systemctl start httpd.service
              systemctl enable httpd.service
              EOF

}

output "ec2web_public_ip" {
  value = aws_instance.ec2web.public_ip
}

