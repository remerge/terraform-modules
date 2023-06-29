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
  dns_name = try(coalesce(var.dns_name, "${var.name}.${var.domain}"), null)
}

resource "google_dns_managed_zone" "private" {
  count       = var.domain != null ? 1 : 0
  name        = "private"
  dns_name    = "grafana.${var.domain}."
  description = "grafana.${var.domain}"
  visibility  = "private"

  private_visibility_config {
    networks {
      network_url = var.network
    }
  }
}