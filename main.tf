provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "custom_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "custom_subnet" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1" 
}

resource "aws_security_group" "custom_sg" {
  vpc_id = aws_vpc.custom_vpc.id
  
}

resource "aws_instance" "custom_server" {
  ami                    = "ami-0e670eb768a5fc3d4   
  instance_type          = "t2.micro"
  key_name               = "Linux-VM-Key7" 
  subnet_id              = aws_subnet.custom_subnet.id
  security_group_ids     = [aws_security_group.custom_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello from Terraform user data!" > /tmp/welcome.txt
              EOF
}

output "instance_ip" {
  value = aws_instance.custom_server.public_ip
}
