locals {
  hostname = coalesce(var.hostname, var.name)
  domain   = try(trimsuffix(var.zone.dns_name, "."), "local")
  fqdn     = "${local.hostname}.${local.domain}"
  metadata = coalesce(var.metadata, local.template.metadata)
  template = data.google_compute_instance_template.main
}

data "google_compute_instance_template" "main" {
  name = var.template
}

resource "google_compute_instance_from_template" "main" {
  source_instance_template = local.template.self_link

  project = var.project

  name     = var.name
  hostname = local.fqdn
  metadata = merge(local.metadata, {
    # https://docs.bridgecrew.io/docs/bc_gcp_networking_8
    block-project-ssh-keys = true
  })

  zone         = var.compute_zone
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

  dynamic "scratch_disk" {
    for_each = range(var.scratch_disk_count)
    content {
      interface = "NVME"
    }
  }

  # checkov:skip=CKV_GCP_32:False positive, keys are blocked
}

resource "google_compute_disk" "main" {
  for_each = var.volumes
  project  = var.project
  zone     = var.compute_zone
  name     = "${var.name}-${each.key}"
  type     = each.value.type
  size     = each.value.size
}

moved {
  from = google_dns_record_set.instance
  to   = module.netbox-vm.google_dns_record_set.main
}

module "netbox-vm" {
  source = "../../netbox/vm"

  project = var.project

  name = local.hostname
  zone = var.zone

  role     = var.role
  platform = var.platform
  site     = var.site
  cluster  = var.cluster

  interface  = var.interface
  ip_address = google_compute_instance_from_template.main.network_interface[0].network_ip
}
