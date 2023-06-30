locals {
  domain   = coalesce(var.dns_name, "${var.name}.${var.domain}")
  dns_name = "${local.domain}."
}

resource "google_dns_managed_zone" "public" {
  project     = var.project
  name        = "public"
  dns_name    = local.dns_name
  description = local.domain

  dnssec_config {
    state = "on"
  }
}

data "google_dns_keys" "public" {
  managed_zone = google_dns_managed_zone.public.name
  depends_on   = [google_dns_managed_zone.public]
}

resource "google_project_service" "certificatemanager" {
  project = var.project
  service = "certificatemanager.googleapis.com"
}

resource "google_dns_record_set" "caa" {
  project      = var.project
  managed_zone = google_dns_managed_zone.public.name
  name         = local.dns_name
  type         = "CAA"
  ttl          = 300
  rrdatas = [
    "0 issue \"pki.goog\"",
    "0 issue \"letsencrypt.org\"",
  ]
}

resource "google_certificate_manager_dns_authorization" "default" {
  project = var.project
  name    = "default"
  domain  = local.domain

  depends_on = [
    google_project_service.certificatemanager,
  ]
}

locals {
  google_dns_auth     = google_certificate_manager_dns_authorization.default
  google_acme_record  = local.google_dns_auth.dns_resource_record[0]
  google_cert_domains = [local.domain, "*.${local.domain}"]
}

resource "google_dns_record_set" "acme" {
  project      = var.project
  managed_zone = google_dns_managed_zone.public.name
  name         = local.google_acme_record.name
  type         = local.google_acme_record.type
  ttl          = 300
  rrdatas      = [local.google_acme_record.data]
}

resource "google_certificate_manager_certificate" "default" {
  project = var.project
  name    = "default"

  managed {
    dns_authorizations = [local.google_dns_auth.id]
    domains            = local.google_cert_domains
  }
}

resource "google_certificate_manager_certificate_map" "default" {
  project = var.project
  name    = "default"
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_certificate_manager_certificate_map_entry" "default" {
  project      = var.project
  count        = length(local.google_cert_domains)
  name         = "default-${count.index}"
  hostname     = local.google_cert_domains[count.index]
  certificates = [google_certificate_manager_certificate.default.id]
  map          = google_certificate_manager_certificate_map.default.name
}