provider "aws" {
  region = "us-east-2" 
}

resource "aws_instance" "name" {
    ami = "ami-0cb91c7de36eed2cb"
    instance_type = "t2.micro"
    subnet_id = "subnet-0f2826d00eaee2f87"
    key_name = "key1"
}

resource "aws_s3_bucket" "s3_bucket" {
      bucket = "harish-s3-demo-0604"
}

resource "aws_dynamodb_table" "terraform_lock" {
       name  = "terraform_lock"
       billing_mode = "PAY_PER_REQUEST"
       hash_key = "LockID"

       attribute {
         name = "LockID"
         type = "S"
       }
}