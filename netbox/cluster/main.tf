data "netbox_cluster_type" "main" {
  name = var.type
}

data "netbox_site" "main" {
  count = var.site != null ? 1 : 0
  name  = var.site
}

resource "netbox_cluster" "main" {
  name            = var.name
  site_id         = var.site != null ? data.netbox_site.main[0].id : null
  cluster_type_id = data.netbox_cluster_type.main.cluster_type_id
  tags            = [var.project]
}
