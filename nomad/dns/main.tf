data "google_dns_managed_zone" "main" {
  project = var.project
  name    = var.domain
}

resource "google_dns_record_set" "apex" {
  project      = var.project
  managed_zone = data.google_dns_managed_zone.main.name
  name         = data.google_dns_managed_zone.main.dns_name
  type         = "A"
  ttl          = 300
  rrdatas      = var.targets
}

resource "google_dns_record_set" "wildcard" {
  project      = var.project
  managed_zone = data.google_dns_managed_zone.main.name
  name         = "*.${data.google_dns_managed_zone.main.dns_name}"
  type         = "A"
  ttl          = 300
  rrdatas      = var.targets
}
