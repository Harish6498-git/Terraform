terraform {
  backend "s3" {
    bucket = "terraform-project-0604"
    region = "us-east-2"
    key = "project/terraform.tfstate"
  }
}