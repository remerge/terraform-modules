terraform {
  required_providers {
    # https://registry.terraform.io/providers/LeaseWeb/leaseweb/latest
    leaseweb = {
      source  = "LeaseWeb/leaseweb"
      version = "~> 1.27"
    }
  }
}
