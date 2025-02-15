locals {
  fqdn       = var.zone != null ? "${var.name}.${trimsuffix(var.zone.dns_name, ".")}" : null
  ip_address = var.ip_address != null ? split("/", var.ip_address)[0] : null
  ip_prefix  = var.ip_address != null ? try(split("/", var.ip_address)[1], "32") : null
  tags       = var.tags != null ? var.tags : try(data.netbox_cluster.main[0].tags, [])
}

resource "netbox_virtual_machine" "main" {
  name        = var.zone != null ? local.fqdn : var.name
  role_id     = data.netbox_device_role.main.id
  platform_id = data.netbox_platform.main.id
  site_id     = var.site != null ? data.netbox_site.main[0].id : null
  cluster_id  = var.cluster != null ? data.netbox_cluster.main[0].id : null
  tags        = local.tags
}

data "netbox_device_role" "main" {
  name = var.role
}

data "netbox_platform" "main" {
  name = var.platform
}

data "netbox_site" "main" {
  count = var.site != null ? 1 : 0
  name  = var.site
}

data "netbox_cluster" "main" {
  count = var.cluster != null ? 1 : 0
  name  = var.cluster
}

moved {
  from = netbox_interface.internal
  to   = netbox_interface.main
}

resource "netbox_interface" "main" {
  count              = var.interface != null ? 1 : 0
  virtual_machine_id = netbox_virtual_machine.main.id
  name               = var.interface
  tags               = local.tags

  lifecycle {
    ignore_changes = [
      description,
      mac_address,
      mtu,
    ]
  }
}

resource "netbox_ip_address" "main" {
  count                        = var.interface != null ? 1 : 0
  virtual_machine_interface_id = netbox_interface.main[0].id
  ip_address                   = "${local.ip_address}/${local.ip_prefix}"
  dns_name                     = local.fqdn
  status                       = "active"
  tags                         = local.tags
}

resource "netbox_primary_ip" "main" {
  count              = var.interface != null ? 1 : 0
  virtual_machine_id = netbox_virtual_machine.main.id
  ip_address_id      = netbox_ip_address.main[0].id
}

resource "google_dns_record_set" "main" {
  count        = var.zone != null ? 1 : 0
  project      = var.project
  managed_zone = var.zone.name
  name         = "${local.fqdn}."
  type         = "A"
  ttl          = 300
  rrdatas      = [local.ip_address]
}
