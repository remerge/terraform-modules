terraform {
  required_providers {
    # https://registry.terraform.io/providers/auth0/auth0/latest
    auth0 = {
      source  = "auth0/auth0"
      version = "~> 1.0"
    }
  }
}
