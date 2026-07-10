terraform {
  required_providers {
    # https://search.opentofu.org/provider/LeaseWeb/leaseweb/latest
    leaseweb = {
      source = "registry.opentofu.org/LeaseWeb/leaseweb"
    }
    # https://search.opentofu.org/provider/hashicorp/random/latest
    random = {
      source = "registry.opentofu.org/hashicorp/random"
    }
  }
}
