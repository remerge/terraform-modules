terraform {
  required_providers {
    # https://registry.terraform.io/providers/hashicorp/google/latest
    google = {
      source = "registry.terraform.io/hashicorp/google"
    }
    # https://registry.terraform.io/providers/e-breuninger/netbox/latest
    netbox = {
      source = "registry.terraform.io/e-breuninger/netbox"
    }
  }
}
