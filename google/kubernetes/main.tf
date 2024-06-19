module "cluster" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version = "v31.0.0"

  project_id = var.project
  name       = var.name
  region     = var.region

  release_channel = "REGULAR"

  network_project_id = var.network.google.project.id
  network            = var.network.google_network.name
  subnetwork         = var.network.google_subnetworks[var.region].name
  ip_range_pods      = "gke-pods-${var.region}"
  ip_range_services  = "gke-services-${var.region}"

  enable_private_endpoint       = true
  enable_private_nodes          = true
  deploy_using_private_endpoint = true

  master_ipv4_cidr_block = var.master_ipv4_cidr_block

  master_authorized_networks = [{
    display_name = "Global Network"
    cidr_block   = "10.0.0.0/8"
  }]

  node_metadata = "GKE_METADATA"
  node_pools = [
    {
      name            = "${var.name}-node-pool"
      machine_type    = var.machine_type
      service_account = module.cluster.service_account

      min_count = var.node_min_count
      max_count = var.node_max_count

      enable_secure_boot          = true
      enable_integrity_monitoring = true
    },
  ]

  remove_default_node_pool = true
}

locals {
  hostname = var.name == var.cluster ? "gke-master" : "gke-master-${module.cluster.name}"
}

module "netbox-vm" {
  source = "../../netbox/vm"

  project = var.project

  name = local.hostname
  zone = var.zone

  role     = "Google Kubernetes Engine Master"
  platform = "Google Cloud"
  site     = var.site
  cluster  = var.cluster

  interface  = "endpoint"
  ip_address = module.cluster.endpoint
}

data "netbox_site" "main" {
  name = var.site
}

resource "netbox_prefix" "master" {
  prefix  = module.cluster.master_ipv4_cidr_block
  status  = "active"
  site_id = data.netbox_site.main.id
  role_id = 16 # provider does not allow lookup yet
  tags    = data.netbox_cluster.main[0].tags
}

data "netbox_cluster" "main" {
  count = var.cluster != null ? 1 : 0
  name  = var.cluster
}
