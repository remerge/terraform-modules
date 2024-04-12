resource "google_certificate_manager_dns_authorization" "default" {
  name   = local.website_domain_name_dashed
  domain = var.website_domain_name
}

resource "google_dns_record_set" "acme" {
  project      = var.domains_project
  managed_zone = var.dns_managed_zone_name
  name         = google_certificate_manager_dns_authorization.default.dns_resource_record[0].name
  type         = google_certificate_manager_dns_authorization.default.dns_resource_record[0].type
  ttl          = 300
  rrdatas      = [google_certificate_manager_dns_authorization.default.dns_resource_record[0].data]
}

resource "google_certificate_manager_certificate" "default" {
  name = local.website_domain_name_dashed

  managed {
    dns_authorizations = [google_certificate_manager_dns_authorization.default.id]
    domains = [
      var.website_domain_name
    ]
  }
}

resource "google_certificate_manager_certificate_map_entry" "default" {
  name         = local.website_domain_name_dashed
  hostname     = google_certificate_manager_certificate.default.managed[0].domains[0]
  certificates = [google_certificate_manager_certificate.default.id]
  map          = var.certificate_map
}
