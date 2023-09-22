resource "google_project_service" "redis" {
  service = "redis.googleapis.com"
}

resource "google_redis_instance" "main" {
  project = var.project
  region  = var.region
  name    = var.name

  memory_size_gb = 1

  authorized_network = var.network
  connect_mode       = "PRIVATE_SERVICE_ACCESS"

  auth_enabled = true

  depends_on = [
    google_project_service.redis,
  ]

  # checkov:skip=CKV_GCP_97:No encryption in private network
}

module "netbox-vm" {
  source = "../../netbox/vm"

  project = var.project

  name = coalesce(var.hostname, var.name)
  zone = var.zone

  role     = "Redis"
  platform = "Google Cloud"
  site     = var.site
  cluster  = var.cluster

  interface  = "internal"
  ip_address = google_redis_instance.main.host
}

resource "google_secret_manager_secret" "auth" {
  secret_id = "redis-auth-${var.name}"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "auth" {
  secret      = google_secret_manager_secret.auth.name
  secret_data = google_redis_instance.main.auth_string
}

resource "google_secret_manager_secret_iam_member" "auth" {
  secret_id = google_secret_manager_secret.auth.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${data.google_compute_default_service_account.default.email}"
}

data "google_compute_default_service_account" "default" {
  project = var.project
}
