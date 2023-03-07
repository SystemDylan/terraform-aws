resource "aws_instance" "ec2basic" {
  ami           = "ami-0f3c9c466bb525749"
  instance_type = "t2.micro"
  tags = {
    Name = "ec2_basic"
  }
}

output "public_ip" {
  value = aws_instance.ec2basic.public_ip
}
