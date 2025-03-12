module "ec2_instance" {
  source              = "./modules/ec2_instance"
  ami_value           = lookup(var.ami_value, terraform.workspace, "ami-0cb91c7de36eed2cb")
  instance_type_value = lookup(var.instance_type_value, terraform.workspace, "t2.micro")
}
