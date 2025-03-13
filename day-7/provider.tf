provider "aws" {
  region = "us-east-2"
}

provider "vault" {
  address          = "http://13.58.47.82:8202"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id   = "d77397dc-b1c6-8ca7-8e85-2b1044ef15ad"
      secret_id = "d631c4bf-19aa-0334-2e34-396d30914309"
    }
  }
}
