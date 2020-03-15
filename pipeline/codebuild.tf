resource "aws_codebuild_project" "salses-unit-test" {
  name = "sales-unit-test"
  service_role = aws_iam_role.codebuild-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "aws/codebuild/standard:1.0"
    type = "LINUX_CONTAINER"
  }
  source {
    type = "CODEPIPELINE"
  }
}