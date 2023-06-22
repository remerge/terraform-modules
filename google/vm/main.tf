locals {
  domain   = var.domain != null ? trimsuffix(var.domain.dns_name, ".") : null
  hostname = var.domain != null ? "${var.name}.${local.domain}" : null
  metadata = var.metadata != null ? var.metadata : local.template.metadata
  template = data.google_compute_instance_template.main
}

data "google_compute_instance_template" "main" {
  name = var.template
}

resource "google_compute_instance_from_template" "main" {
  source_instance_template = local.template.self_link_unique

  project = var.project
  zone    = var.zone

  name     = var.name
  hostname = local.hostname
  metadata = merge(local.metadata, {
    # https://docs.bridgecrew.io/docs/bc_gcp_networking_8
    block-project-ssh-keys = true
  })

  machine_type = var.machine_type

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
  project  = var.project
  name     = "${var.name}-${each.key}"
  type     = each.value.type
  size     = each.value.size
}

resource "google_dns_record_set" "instance" {
  count        = var.domain != null ? 1 : 0
  project      = var.project
  managed_zone = var.domain.name
  name         = "${google_compute_instance_from_template.main.hostname}."
  type         = "A"
  ttl          = 300
  rrdatas      = [google_compute_instance_from_template.main.network_interface[0].network_ip]
}

module "netbox-vm" {
  source = "../../netbox/vm"

  name = google_compute_instance_from_template.main.hostname

  role     = var.role
  platform = var.platform
  site     = var.site
  cluster  = var.cluster
  tags     = [var.project]

  interface  = var.interface
  ip_address = "${google_compute_instance_from_template.main.network_interface[0].network_ip}/32"
}
