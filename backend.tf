terraform {
  backend "s3" {
    encrypt = true
    bucket = "sales-infrastructure-backend"
    dynamodb_table = "sales-infrastructure-dynamoTable"
    region = "eu-west-1"
    key = "sales/terraform.tfstate"
  }
}