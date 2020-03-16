data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "sales-infrastructure-backend"
    key    = "sales/terraform.tfstate"
    region = "eu-west-1"
  }
}
