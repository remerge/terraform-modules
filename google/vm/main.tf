locals {
  domain   = trimsuffix(var.domain.dns_name, ".")
  hostname = var.domain != null ? "${var.name}.${local.domain}" : var.name
  metadata = length(var.metadata) > 0 ? var.metadata : var.template.metadata
}

resource "google_compute_instance_from_template" "main" {
  source_instance_template = var.template.self_link_unique

  name    = var.name
  project = var.project
  zone    = var.zone

  machine_type = var.machine_type

  hostname = local.hostname
  metadata = merge(local.metadata, {
    # https://docs.bridgecrew.io/docs/bc_gcp_networking_8
    block-project-ssh-keys = true
  })

  boot_disk {
    device_name = "boot"
    initialize_params {
      image = var.disk_image
      type  = "pd-ssd"
      size  = var.disk_size
    }
  }

  dynamic "attached_disk" {
    for_each = var.volumes
    content {
      source      = google_compute_disk.main[attached_disk.key].self_link
      device_name = attached_disk.key
    }
  }

  # checkov:skip=CKV_GCP_32:False positive, keys are blocked
}

resource "google_compute_disk" "main" {
  for_each = var.volumes
  name     = "${var.name}-${each.key}"
  type     = each.value.type
  size     = each.value.size
}

resource "google_dns_record_set" "netbox" {
  count        = var.domain != null ? 1 : 0
  managed_zone = var.domain.name
  name         = "${google_compute_instance_from_template.main.hostname}."
  type         = "A"
  ttl          = 300
  rrdatas      = [google_compute_instance_from_template.main.network_interface[0].network_ip]
}
