resource "aws_instance" "jump_server" {
  ami                         = data.aws_ami.ami.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public-subnet.id
  associate_public_ip_address = true
  key_name                    = var.key-name
  iam_instance_profile        = aws_iam_instance_profile.jump_instance_profile.name

  user_data = file("tools-install.sh")  # Ensure this script is in your Terraform directory

  tags = {
    Name = var.instance-name
  }
}

resource "aws_security_group" "jump_server_sg" {
  vpc_id = aws_vpc.vpc.id

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
    Name = "jump-server-sg"
  }
}
