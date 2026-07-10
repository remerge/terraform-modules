terraform {
  required_providers {
    # https://registry.terraform.io/providers/hashicorp/google/latest
    google = {
      source = "hashicorp/google"
    }
    # https://registry.terraform.io/providers/okta/oktapam/latest
    oktapam = {
      source = "okta/oktapam"
    }
  }
}
