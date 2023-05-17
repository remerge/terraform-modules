resource "netbox_virtual_machine" "main" {
  name        = var.name
  role_id     = var.role != null ? var.role.id : null
  site_id     = var.site != null ? var.site.id : null
  cluster_id  = var.cluster != null ? var.cluster.id : null
  platform_id = var.platform != null ? var.platform.id : null
  tags        = var.tags
}

resource "netbox_interface" "internal" {
  count              = var.interface != null ? 1 : 0
  virtual_machine_id = netbox_virtual_machine.main.id
  name               = var.interface
  tags               = var.tags
}

resource "netbox_ip_address" "main" {
  count        = var.interface != null ? 1 : 0
  interface_id = netbox_interface.internal[0].id
  ip_address   = "${var.ip_address}/32"
  status       = "active"
  tags         = var.tags
}

resource "netbox_primary_ip" "main" {
  count              = var.interface != null ? 1 : 0
  virtual_machine_id = netbox_virtual_machine.main.id
  ip_address_id      = netbox_ip_address.main[0].id
}
