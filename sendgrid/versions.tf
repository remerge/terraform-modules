terraform {
  required_providers {
    # https://registry.terraform.io/providers/hashicorp/google/latest
    google = {
      source  = "hashicorp/google"
      version = "~> 5.3"
    }
    # https://registry.terraform.io/providers/Trois-Six/sendgrid/latest
    sendgrid = {
      source  = "Trois-Six/sendgrid"
      version = "~> 0.2"
    }
  }
}
