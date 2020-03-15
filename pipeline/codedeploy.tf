resource "aws_codedeploy_app" "sales-deploy" {
  compute_platform = "Server"
  name             = "sales-deploy"
}

resource "aws_codedeploy_deployment_config" "deployment-config" {
  deployment_config_name = "deployment-config"

  minimum_healthy_hosts {
    type  = "HOST_COUNT"
    value = 0
  }
}

resource "aws_codedeploy_deployment_group" "deployment_group" {
  app_name               = aws_codedeploy_app.sales-deploy.name
  deployment_group_name  = aws_codedeploy_app.sales-deploy.name
  service_role_arn       = aws_iam_role.codedeploy-role.arn
  deployment_config_name = aws_codedeploy_deployment_config.deployment-config.id

  ec2_tag_filter {
    key   = "Name"
    type  = "KEY_AND_VALUE"
    value = "Sales"
  }
}