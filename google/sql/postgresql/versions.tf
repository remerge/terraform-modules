terraform {
  required_providers {
    # https://registry.terraform.io/providers/hashicorp/google/latest
    google = {
      source = "registry.terraform.io/hashicorp/google"
    }
    # https://registry.terraform.io/providers/hashicorp/random/latest
    random = {
      source = "registry.terraform.io/hashicorp/random"
    }
  }
}
