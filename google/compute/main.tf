locals {
  hostname = coalesce(var.hostname, var.name)
  domain   = try(trimsuffix(var.zone.dns_name, "."), "local")
  fqdn     = "${local.hostname}.${local.domain}"
  template = data.google_compute_instance_template.main

  base_metadata = coalesce(var.metadata, local.template.metadata)
  metadata = var.startup_script_extra == null ? local.base_metadata : merge(local.base_metadata, {
    startup-script = trimspace(join("\n", [
      try(local.base_metadata["startup-script"], ""),
      var.startup_script_extra,
    ]))
  })
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

  dynamic "scheduling" {
    for_each = var.on_host_maintenance == null ? [] : [1]
    content {
      on_host_maintenance = var.on_host_maintenance
    }
  }

  # A GPU that is not implied by the machine type has to be attached. G2 and A2
  # carry theirs, N1 does not.
  dynamic "guest_accelerator" {
    for_each = var.guest_accelerator == null ? [] : [var.guest_accelerator]
    content {
      type  = guest_accelerator.value.type
      count = guest_accelerator.value.count
    }
  }

  # Subnetworks are regional, so an instance placed outside the template's
  # region needs its own. Overriding this replaces the template's interface,
  # which carries no external address either.
  dynamic "network_interface" {
    for_each = var.subnetwork == null ? [] : [1]
    content {
      subnetwork         = var.subnetwork
      subnetwork_project = var.subnetwork_project
    }
  }

  boot_disk {
    auto_delete = true
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
