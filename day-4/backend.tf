terraform {
  backend "s3" {
    bucket = "harish-s3-demo-0604"
    region = "us-east-2"
    key = "harish/terraform.tfstate"
    dynamodb_table = "terraform_lock"
  }
}