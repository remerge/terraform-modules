terraform {
  required_providers {
    # https://registry.terraform.io/providers/hashicorp/google/latest
    google = {
      source  = "hashicorp/google"
      version = "~> 4.64"
    }
    # https://registry.terraform.io/providers/okta/oktapam/latest
    oktapam = {
      source  = "okta/oktapam"
      version = "~> 0.4"
    }
  }
}
