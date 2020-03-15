resource "aws_iam_role" "codedeploy-role" {
  assume_role_policy = data.aws_iam_policy_document.codedeploy-role-document.json
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.codedeploy-role.name
}

data "aws_iam_policy_document" "codedeploy-role-document" {
  statement {
    actions = [
      "sts:AssumeRole"]
    principals {
      identifiers = ["codedeploy.amazonaws.com"]
      type = "Service"
    }
  }
}