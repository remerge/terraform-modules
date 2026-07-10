terraform {
  required_providers {
    # https://registry.terraform.io/providers/hashicorp/nomad/latest
    nomad = {
      source = "hashicorp/nomad"
    }
    # https://registry.terraform.io/providers/1Password/onepassword/latest
    onepassword = {
      source = "1Password/onepassword"
    }
  }
}
