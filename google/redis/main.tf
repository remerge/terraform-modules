resource "google_project_service" "redis" {
  service = "redis.googleapis.com"
}

resource "google_redis_instance" "main" {
  project = var.project
  region  = var.region
  name    = var.name

  redis_version = var.redis_version

  memory_size_gb = var.memory

  authorized_network = var.network
  connect_mode       = "PRIVATE_SERVICE_ACCESS"

  auth_enabled = true

  persistence_config {
    persistence_mode    = var.persistence_mode
    rdb_snapshot_period = var.persistence_period
  }

  redis_configs = {
    maxmemory-policy = var.maxmemory_policy
  }

  depends_on = [
    google_project_service.redis,
  ]

  # checkov:skip=CKV_GCP_97:No encryption in private network
}

module "netbox-vm" {
  source = "../../netbox/vm"

  project = var.project

  name = var.name
  tags = [var.workspace]

  role     = "Redis"
  platform = "Google Cloud"
  site     = "Google Cloud ${google_redis_instance.main.region}"

  interface  = "internal"
  ip_address = google_redis_instance.main.host
}
