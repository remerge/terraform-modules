terraform {
  required_providers {
    # https://search.opentofu.org/provider/hashicorp/google/latest
    google = {
      source = "registry.opentofu.org/hashicorp/google"
    }
    terracurl = {
      source = "registry.opentofu.org/devops-rob/terracurl"
    }
  }
}
