locals {
  domain = try(coalesce(var.dns_name, "${var.name}.${var.domain}"), null)
}

resource "google_dns_managed_zone" "public" {
  project     = var.project
  name        = "public"
  dns_name    = "${local.domain}."
  description = local.domain

  dnssec_config {
    state = "on"
  }
}

data "google_dns_keys" "public" {
  managed_zone = google_dns_managed_zone.public.name
  depends_on   = [google_dns_managed_zone.public]
}
