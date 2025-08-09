locals {
  hostname   = coalesce(var.hostname, var.name)
  domain     = try(trimsuffix(var.zone.dns_name, "."), "local")
  fqdn       = "${local.hostname}.${local.domain}"
  ip_address = var.ip_address != null ? split("/", var.ip_address)[0] : null
  ip_prefix  = var.ip_address != null ? try(split("/", var.ip_address)[1], "32") : null
  tags       = var.tags != null ? var.tags : data.netbox_cluster.main[0].tags
}

resource "netbox_device" "main" {
  name           = local.fqdn
  role_id        = data.netbox_device_role.main.id
  platform_id    = data.netbox_platform.main.id
  device_type_id = data.netbox_device_type.main.id
  site_id        = var.site != null ? data.netbox_site.main[0].id : null
  cluster_id     = var.cluster != null ? data.netbox_cluster.main[0].id : null
  asset_tag      = var.asset_tag
  tags           = local.tags

  lifecycle {
    ignore_changes = [
      serial,
    ]
  }
}

data "netbox_device_role" "main" {
  name = var.role
}

data "netbox_device_type" "main" {
  model = var.model
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

resource "netbox_device_interface" "main" {
  count     = var.interface != null ? 1 : 0
  device_id = netbox_device.main.id
  type      = var.interface_type
  name      = var.interface
  tags      = local.tags

  lifecycle {
    ignore_changes = [
      description,
      label,
      mtu,
      speed,
    ]
  }
}

resource "netbox_ip_address" "main" {
  count               = var.interface != null ? 1 : 0
  device_interface_id = netbox_device_interface.main[0].id
  ip_address          = "${local.ip_address}/${local.ip_prefix}"
  dns_name            = local.fqdn
  status              = "active"
  tags                = local.tags
}

resource "netbox_device_primary_ip" "main" {
  count         = var.interface != null ? 1 : 0
  device_id     = netbox_device.main.id
  ip_address_id = netbox_ip_address.main[0].id
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
