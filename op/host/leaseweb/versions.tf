terraform {
  required_providers {
    # https://registry.terraform.io/providers/1Password/onepassword/latest
    onepassword = {
      source = "registry.terraform.io/1Password/onepassword"
    }
    # https://registry.terraform.io/providers/LeaseWeb/leaseweb/latest
    leaseweb = {
      source = "registry.terraform.io/LeaseWeb/leaseweb"
    }
  }
}
