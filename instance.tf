resource "aws_security_group" "webserver-security-group" {
  name        = "allow-ssh-http"
  description = "Allow ssh and http traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_http"
  }
}

resource "aws_instance" "webserver" {
  ami = var.instance_ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.public.id
  associate_public_ip_address = true
  key_name = var.key_name
  security_groups = [aws_security_group.webserver-security-group.id]

  user_data = data.template_file.user-data.rendered
}

data "template_file" "user-data" {
  template = "${file("${path.module}/assets/webserver-userdata.sh")}"
}


