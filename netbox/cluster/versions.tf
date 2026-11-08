terraform {
  required_providers {
    # https://registry.terraform.io/providers/hashicorp/google/latest
    google = {
      source = "hashicorp/google"
    }
    # https://registry.terraform.io/providers/e-breuninger/netbox/latest
    netbox = {
      source = "e-breuninger/netbox"
      # v6 is a rewrite that renames resources these modules use; migrate before lifting
      version = "< 6.0.0"
    }
  }
}
