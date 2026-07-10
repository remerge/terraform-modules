terraform {
  required_providers {
    # https://search.opentofu.org/provider/hashicorp/nomad/latest
    nomad = {
      source = "registry.opentofu.org/hashicorp/nomad"
    }
    # https://search.opentofu.org/provider/1Password/onepassword/latest
    onepassword = {
      source = "registry.opentofu.org/1Password/onepassword"
    }
  }
}
