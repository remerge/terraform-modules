terraform {
  required_providers {
    # https://search.opentofu.org/provider/1Password/onepassword/latest
    onepassword = {
      source = "registry.opentofu.org/1Password/onepassword"
    }
    # https://search.opentofu.org/provider/LeaseWeb/leaseweb/latest
    leaseweb = {
      source = "registry.opentofu.org/LeaseWeb/leaseweb"
    }
  }
}
