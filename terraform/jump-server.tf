resource "aws_instance" "jump_server" {
  ami                         = "ami-0c55b159cbfafe1f0"  # Update this to the latest Amazon Linux 2 AMI
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public[0].id
  associate_public_ip_address = true
  key_name                    = "your-key-pair"  # Update this with your key pair name
  iam_instance_profile        = aws_iam_instance_profile.jump_instance_profile.name

  user_data = file("tools-install.sh")  # User data script for installing tools

  tags = {
    Name = "Jump-Server"
  }
}

resource "aws_security_group" "jump_server_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jump-Server-SG"
  }
}
