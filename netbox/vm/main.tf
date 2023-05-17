resource "netbox_virtual_machine" "main" {
  name       = var.name
  role_id    = var.role_id
  site_id    = var.site_id
  cluster_id = var.cluster_id
  tags       = var.tags
}

resource "netbox_interface" "internal" {
  count              = var.ip_address != null ? 1 : 0
  virtual_machine_id = netbox_virtual_machine.main.id
  name               = "internal"
  tags               = var.tags
}

resource "netbox_ip_address" "main" {
  count        = var.ip_address != null ? 1 : 0
  interface_id = netbox_interface.internal[0].id
  ip_address   = "${var.ip_address}/32"
  status       = "active"
  tags         = var.tags
}

resource "netbox_primary_ip" "main" {
  count              = var.ip_address != null ? 1 : 0
  virtual_machine_id = netbox_virtual_machine.main.id
  ip_address_id      = netbox_ip_address.main[0].id
}
