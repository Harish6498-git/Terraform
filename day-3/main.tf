provider "aws" {
    region = "us-east-2"
  
}

module "ec2_instance" {
    source = "./modules/ec2_instance"
    ami_value           = "ami-0cb91c7de36eed2cb"
    instance_type_value = "t2.micro"
    subnet_id_value     = "subnet-0f2826d00eaee2f87"
    key_value           = "key1"
}