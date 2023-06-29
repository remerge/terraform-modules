resource "google_dns_record_set" "quorum" {
  project      = var.project
  managed_zone = var.domain.name
  name         = "quorum.${var.domain.description}."
  type         = "A"
  ttl          = 300
  rrdatas      = var.targets
}

resource "google_dns_managed_zone" "consul" {
  project     = var.project
  name        = "consul"
  dns_name    = "${var.name}.consul."
  description = "${var.name}.consul"
  visibility  = "private"

  private_visibility_config {
    networks {
      network_url = var.network.id
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
