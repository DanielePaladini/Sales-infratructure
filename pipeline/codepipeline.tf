resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "salses-pipeline-bucket-artifact"
  acl    = "private"
}





data "aws_ssm_parameter" "github-token" {
  name = var.github-token
}
resource "aws_codepipeline" "codepipeline" {
  name = "sales-codepipeline"
  role_arn = aws_iam_role.pipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type = "S3"
  }
  stage {
    name = "Source"

    action {
      category = "Source"
      name = "Source"
      owner = "ThirdParty"
      provider = "GitHub"
      version = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner  = "DanielePaladini"
        Repo   = "sale-taxes"
        Branch = "master"
        OAuthToken = data.aws_ssm_parameter.github-token.value
      }
    }
  }

  stage {
    name = "Test-And-Build"

    action {
      name             = "Test-And-Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = aws_codebuild_project.salses-unit-test.id
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name = "Deploy"
      category = "Deploy"
      owner = "AWS"
      provider = "CodeDeploy"
      version = "1"
      input_artifacts = ["build_output"]

      configuration = {
        ApplicationName = aws_codedeploy_app.sales-deploy.name
        DeploymentGroupName = aws_codedeploy_deployment_group.deployment_group.app_name
      }
    }


  }
}