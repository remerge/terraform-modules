terraform {
  required_providers {
    # https://registry.terraform.io/providers/Trois-Six/sendgrid/latest
    sendgrid = {
      source  = "Trois-Six/sendgrid"
      version = "~> 0.2"
    }
  }
}
