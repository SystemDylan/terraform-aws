resource "aws_instance" "ec2basic" {
  ami           = "ami-0f3c9c466bb525749"
  instance_type = "t2.micro"
  vpc_security_group_ids = [
    var.security_group_id,
  ]
  tags = {
    Name = "ec2_basic"
  }
}

output "ec2basic_public_ip" {
  value = aws_instance.ec2basic.public_ip
}
