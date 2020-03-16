resource "aws_iam_role" "ec2-role" {
  name = "ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2-role-document.json
}

resource "aws_iam_role_policy" "ec2-role-policy" {
  name = "ec2-role-policy"
  policy = data.aws_iam_policy_document.ec2-policy-document.json
  role = aws_iam_role.ec2-role.id
}

data "aws_iam_policy_document" "ec2-role-document" {
  statement {
    actions = [
      "sts:AssumeRole"]
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type = "Service"
    }
  }
}

resource "aws_iam_instance_profile" "ec2-profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2-role.id
}

data "aws_iam_policy_document" "ec2-policy-document" {
  statement {
    actions = [
      "s3:*"]
    resources = ["*"]
  }
  statement {
    actions = [
      "ec2:DescribeAddresses",
      "ec2:AllocateAddress",
      "ec2:DescribeInstances",
      "ec2:AssociateAddress"]
    resources = ["*"]
  }
}