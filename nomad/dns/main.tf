resource "google_dns_record_set" "apex" {
  project      = var.project
  managed_zone = var.domain.name
  name         = var.domain.dns_name
  type         = "A"
  ttl          = 300
  rrdatas      = var.targets
}

resource "google_dns_record_set" "wildcard" {
  project      = var.project
  managed_zone = var.domain.name
  name         = "*.${var.domain.dns_name}"
  type         = "A"
  ttl          = 300
  rrdatas      = var.targets
}
