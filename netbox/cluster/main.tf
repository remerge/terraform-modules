data "netbox_cluster_type" "main" {
  name = var.type
}

data "netbox_site" "main" {
  count = var.site != null ? 1 : 0
  name  = var.site
}

resource "netbox_cluster" "main" {
  name            = var.name
  site_id         = var.site != null ? data.netbox_site.main[0].id : null
  cluster_type_id = data.netbox_cluster_type.main.cluster_type_id
  tags            = [var.project]
}

locals {
  domain = try(coalesce(var.dns_name, "${var.name}.${var.domain}"), null)
}

resource "google_dns_managed_zone" "private" {
  count       = var.domain != null ? 1 : 0
  project     = var.project
  name        = var.name
  dns_name    = "${local.domain}."
  description = local.domain
  visibility  = "private"

  private_visibility_config {
    networks {
      network_url = var.network
    }
  }
}

resource "google_dns_record_set" "main" {
  for_each     = var.dns_records
  managed_zone = google_dns_managed_zone.private[0].name
  name         = "${each.key}.${google_dns_managed_zone.private[0].dns_name}"
  type         = "A"
  ttl          = 300
  rrdatas      = [each.value]
}
