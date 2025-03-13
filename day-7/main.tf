data "vault_kv_secret_v2" "example" {
  mount = "kv"
  name  = "test_key"
}

resource "aws_instance" "example" {
  ami           = var.ami_value
  instance_type = var.instance_type_value

  tags = {
    name = "test"
    Secret = data.vault_kv_secret_v2.example.data["username"]
  }
}

resource "aws_s3_bucket" "example" {
  bucket = data.vault_kv_secret_v2.example.data["username"]
}
