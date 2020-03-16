data "template_file" "user-data" {
  template = "${file("${path.module}/assets/webserver-userdata.sh")}"

  depends_on = [aws_eip.elastic_ip]
  vars = {
    EPID    = aws_eip.elastic_ip.public_ip
    REGION  = var.region
  }
}


resource "aws_launch_configuration" "launch_configuration_webserver" {
  image_id                    = var.instance_ami
  instance_type               = var.instance_type
  associate_public_ip_address = true
  key_name                    = var.key_name
  security_groups             = [aws_security_group.webserver-security-group.id]
  user_data                   = data.template_file.user-data.rendered
  iam_instance_profile        = aws_iam_instance_profile.ec2-profile.id
}

resource "aws_autoscaling_group" "autoscaling_group_webserve" {
  max_size = 1
  min_size = 1
  vpc_zone_identifier = [aws_subnet.public.id]
  launch_configuration = aws_launch_configuration.launch_configuration_webserver.id

  tag {
    key = "Name"
    propagate_at_launch = true
    value = "Sales"
  }
}
output "autoscaling_gourp" {
  value = aws_autoscaling_group.autoscaling_group_webserve.id
}

resource "aws_eip" "elastic_ip" {
  vpc = true

  tags = {
    Name = "Sales"
  }
}
