terraform {
  required_providers {
    # https://registry.terraform.io/providers/hashicorp/nomad/latest
    nomad = {
      source  = "hashicorp/nomad"
      version = "~> 2.5"
    }
    # https://registry.terraform.io/providers/1Password/onepassword/latest
    onepassword = {
      source  = "1Password/onepassword"
      version = "~> 2.1.2"
    }
  }
}
