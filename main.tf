provider "aws" {
  region = "us-east-2"
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP test page
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  ami                    = "ami-077b630ef539aa0b5"
  instance_type          = "t3.micro"
  key_name               = "my-key"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
    #!/bin/bash
    cd /home/ec2-user
    echo "Hello, World" > index.html
    nohup python3 -m http.server 8080 &
  EOF

  tags = {
    Name = "terraform-example"
  }
}