terraform {
  required_providers {
    # https://registry.terraform.io/providers/1Password/onepassword/latest
    onepassword = {
      source  = "1Password/onepassword"
      version = "~> 2.1"
    }
    # https://registry.terraform.io/providers/LeaseWeb/leaseweb/latest
    leaseweb = {
      source  = "LeaseWeb/leaseweb"
      version = "~> 1.27"
    }
  }
}
