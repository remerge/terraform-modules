terraform {
  required_providers {
    # https://registry.terraform.io/providers/1Password/onepassword/latest
    onepassword = {
      source  = "1Password/onepassword"
      version = "~> 1.3"
    }
    # https://registry.terraform.io/providers/LeaseWeb/leaseweb/latest
    leaseweb = {
      source  = "LeaseWeb/leaseweb"
      version = "~> 0.4"
    }
  }
}
