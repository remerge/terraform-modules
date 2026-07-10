terraform {
  required_providers {
    # https://registry.terraform.io/providers/LeaseWeb/leaseweb/latest
    leaseweb = {
      source = "registry.terraform.io/LeaseWeb/leaseweb"
    }
    # https://registry.terraform.io/providers/hashicorp/random/latest
    random = {
      source = "registry.terraform.io/hashicorp/random"
    }
  }
}
