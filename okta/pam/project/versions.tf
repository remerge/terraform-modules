terraform {
  required_providers {
    # https://registry.terraform.io/providers/hashicorp/google/latest
    google = {
      source = "registry.terraform.io/hashicorp/google"
    }
    # https://registry.terraform.io/providers/okta/oktapam/latest
    oktapam = {
      source = "registry.terraform.io/okta/oktapam"
    }
  }
}
