terraform {
  required_providers {
    # https://registry.terraform.io/providers/LeaseWeb/leaseweb/latest
    leaseweb = {
      # source  = "LeaseWeb/leaseweb"
      source  = "hollow/leaseweb"
      version = "0.3.3-1"
    }
  }
}
