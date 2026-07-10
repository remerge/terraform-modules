terraform {
  required_providers {
    # https://search.opentofu.org/provider/hashicorp/google/latest
    google = {
      source = "registry.opentofu.org/hashicorp/google"
    }
    # https://search.opentofu.org/provider/hashicorp/random/latest
    random = {
      source = "registry.opentofu.org/hashicorp/random"
    }
  }
}
