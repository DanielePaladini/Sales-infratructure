resource "aws_iam_role" "pipeline_role" {
  name = "pipeline-role"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_role_document.json
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline-policy"
  policy = data.aws_iam_policy_document.codepipeline_policy_document.json
  role = aws_iam_role.pipeline_role.id
}

data "aws_iam_policy_document" "codepipeline_role_document" {
  statement {
    actions = [
      "sts:AssumeRole"]
    principals {
      identifiers = ["codepipeline.amazonaws.com"]
      type = "Service"
    }
  }
}

data "aws_iam_policy_document" "codepipeline_policy_document" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObject"]
    resources = [
      aws_s3_bucket.codepipeline_bucket.arn,
      "${aws_s3_bucket.codepipeline_bucket.arn}/*"]
  }
  statement {
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild"]
    resources = ["*"]
  }
  statement {
    actions = [
      "codedeploy:CreateDeployment",
      "codedeploy:GetApplicationRevision",
      "codedeploy:GetDeployment",
      "codedeploy:GetDeploymentConfig",
      "codedeploy:RegisterApplicationRevision"]
    resources = ["*"]
  }
}
