locals {
  hostname   = coalesce(var.hostname, var.name)
  domain     = try(trimsuffix(var.zone.dns_name, "."), "local")
  fqdn       = "${local.hostname}.${local.domain}"
  ip_address = var.ip_address != null ? split("/", var.ip_address)[0] : null
  ip_prefix  = var.ip_address != null ? try(split("/", var.ip_address)[1], "32") : null

  role_id        = var.role_id != null ? var.role_id : data.netbox_device_role.main[0].id
  platform_id    = var.platform_id != null ? var.platform_id : data.netbox_platform.main[0].id
  device_type_id = var.device_type_id != null ? var.device_type_id : data.netbox_device_type.main[0].id
  site_id        = var.site_id != null ? var.site_id : (var.site != null ? data.netbox_site.main[0].id : null)
  cluster_id     = var.cluster_id != null ? var.cluster_id : (var.cluster != null ? data.netbox_cluster.main[0].id : null)

  # tags fall back to the cluster's tags only when the cluster is looked up by
  # name; with cluster_id there is no lookup and therefore no tag inheritance
  tags = var.tags != null ? var.tags : (var.cluster != null && var.cluster_id == null ? data.netbox_cluster.main[0].tags : [])
}

resource "netbox_device" "main" {
  name           = local.fqdn
  role_id        = local.role_id
  platform_id    = local.platform_id
  device_type_id = local.device_type_id
  site_id        = local.site_id
  cluster_id     = local.cluster_id
  asset_tag      = var.asset_tag
  tags           = local.tags

  # rack placement; all null when no rack is given (face is required whenever
  # position is set)
  rack_id       = var.rack_id
  location_id   = var.location_id
  rack_position = var.rack_id != null && var.rack != null ? var.rack.position : null
  rack_face     = var.rack_id != null && var.rack != null ? var.rack.face : null

  lifecycle {
    ignore_changes = [
      serial,
    ]
  }
}

data "netbox_device_role" "main" {
  count = var.role_id == null ? 1 : 0
  name  = var.role
}

data "netbox_device_type" "main" {
  count = var.device_type_id == null ? 1 : 0
  model = var.model
}

data "netbox_platform" "main" {
  count = var.platform_id == null ? 1 : 0
  name  = var.platform
}

data "netbox_site" "main" {
  count = var.site_id == null && var.site != null ? 1 : 0
  name  = var.site
}

data "netbox_cluster" "main" {
  count = var.cluster_id == null && var.cluster != null ? 1 : 0
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
