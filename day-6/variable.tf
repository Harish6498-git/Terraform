variable "ami_value" {
  description = "value for the ami"
  type        = map(string)

  default = {
    "dev" = "ami-0cb91c7de36eed2cb"
    "prod" = "ami-0d0f28110d16ee7d6"
    "stage" = "ami-05188fcabea1c2e9f"
  }
}

variable "instance_type_value" {
  description = "value for the instance_type"
  type        = map(string)

  default = {
    "dev" = "t2.micro"
    "prod" = "t2.medium"
    "stage" = "t3.medium"
  }
}