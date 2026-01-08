terraform {
  required_providers {
    # https://registry.terraform.io/providers/hashicorp/google/latest
    google = {
      source = "hashicorp/google"
    }
    terracurl = {
      source  = "devops-rob/terracurl"
      version = "2.0.0"
    }
  }
}
