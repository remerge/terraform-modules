terraform {
  required_providers {
    # https://registry.terraform.io/providers/hashicorp/nomad/latest
    nomad = {
      source = "registry.terraform.io/hashicorp/nomad"
    }
    # https://registry.terraform.io/providers/1Password/onepassword/latest
    onepassword = {
      source = "registry.terraform.io/1Password/onepassword"
    }
  }
}
