resource "aws_iam_role" "codebuild-role" {
  name = "codebuild-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild-role-document.json
}

resource "aws_iam_role_policy" "codebuild-role-policy" {
  name = "codebuild-role-policy"
  policy = data.aws_iam_policy_document.codebuild-policy-document.json
  role = aws_iam_role.codebuild-role.id
}

data "aws_iam_policy_document" "codebuild-role-document" {
  statement {
    actions = [
      "sts:AssumeRole"]
    principals {
      identifiers = ["codebuild.amazonaws.com"]
      type = "Service"
    }
  }
}

data "aws_iam_policy_document" "codebuild-policy-document" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"]
    resources = ["*"]
  }
  statement {
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs"]
    resources = ["*"]
  }
  statement {
    actions = [
      "s3:*"]
    resources = [
      aws_s3_bucket.codepipeline_bucket.arn,
      "${aws_s3_bucket.codepipeline_bucket.arn}/*"]
  }
}