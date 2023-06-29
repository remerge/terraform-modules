data "google_dns_managed_zone" "main" {
  project = var.project
  name    = var.domain
}

resource "google_dns_record_set" "quorum" {
  project      = var.project
  managed_zone = var.domain
  name         = "quorum.${data.google_dns_managed_zone.main.dns_name}"
  type         = "A"
  ttl          = 300
  rrdatas      = var.targets
}

resource "google_dns_managed_zone" "consul" {
  project     = var.project
  name        = "${var.name}-consul"
  dns_name    = "${var.name}.consul."
  description = "${var.name}.consul"
  visibility  = "private"

  private_visibility_config {
    networks {
      network_url = var.network
    }
  }

  forwarding_config {
    dynamic "target_name_servers" {
      for_each = var.targets
      content {
        ipv4_address = target_name_servers.value
      }
    }
  }
}
