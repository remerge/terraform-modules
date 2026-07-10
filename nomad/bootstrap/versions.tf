terraform {
  required_providers {
    # https://registry.terraform.io/providers/hashicorp/google/latest
    google = {
      source = "registry.terraform.io/hashicorp/google"
    }
    terracurl = {
      source = "registry.terraform.io/devops-rob/terracurl"
    }
  }
}
