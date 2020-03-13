resource "aws_iam_role_policy" "ec2-policy" {
  policy = file("${path.module}/assets/ec2-policy.json")
  role = aws_iam_role.ec2_role.id
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"
  assume_role_policy = file("${path.module}/assets/assume-role-policy.json")
}

resource "aws_iam_instance_profile" "ec2-profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_role.id
}