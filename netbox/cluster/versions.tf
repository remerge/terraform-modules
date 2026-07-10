terraform {
  required_providers {
    # https://search.opentofu.org/provider/hashicorp/google/latest
    google = {
      source = "registry.opentofu.org/hashicorp/google"
    }
    # https://search.opentofu.org/provider/e-breuninger/netbox/latest
    netbox = {
      source = "registry.opentofu.org/e-breuninger/netbox"
    }
  }
}
