terraform {
  required_providers {
    # https://search.opentofu.org/provider/hashicorp/google/latest
    google = {
      source = "registry.opentofu.org/hashicorp/google"
    }
    # https://search.opentofu.org/provider/okta/oktapam/latest
    oktapam = {
      source = "registry.opentofu.org/okta/oktapam"
    }
  }
}
