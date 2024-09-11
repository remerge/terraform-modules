terraform {
  required_providers {
    # https://registry.terraform.io/providers/hashicorp/google/latest
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
    # https://registry.terraform.io/providers/e-breuninger/netbox/latest
    netbox = {
      source  = "e-breuninger/netbox"
      version = "~> 3.3"
    }
  }
}
