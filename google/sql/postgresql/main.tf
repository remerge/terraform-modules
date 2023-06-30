resource "google_project_service" "sqladmin" {
  project = var.project
  service = "sqladmin.googleapis.com"
}

resource "google_sql_database_instance" "main" {
  project = var.project
  name    = var.name
  region  = var.region

  database_version = var.database_version

  settings {
    tier = var.tier

    ip_configuration {
      require_ssl     = false
      ipv4_enabled    = false
      private_network = var.network
    }

    availability_type = "REGIONAL"

    backup_configuration {
      enabled  = true
      location = var.backup.location
      # required for regional availability
      point_in_time_recovery_enabled = true
    }

    insights_config {
      query_insights_enabled = true
    }

    # https://docs.bridgecrew.io/docs/bc_gcp_sql_2
    database_flags {
      name  = "log_checkpoints"
      value = "on"
    }

    # https://docs.bridgecrew.io/docs/bc_gcp_sql_3
    database_flags {
      name  = "log_connections"
      value = "on"
    }

    # https://docs.bridgecrew.io/docs/bc_gcp_sql_4
    database_flags {
      name  = "log_disconnections"
      value = "on"
    }

    # https://docs.bridgecrew.io/docs/bc_gcp_sql_5
    database_flags {
      name  = "log_lock_waits"
      value = "on"
    }

    # CKV_GCP_108
    database_flags {
      name  = "log_hostname"
      value = "on"
    }

    # CKV_GCP_109
    database_flags {
      name  = "log_min_error_statement"
      value = "error"
    }
  }

  depends_on = [
    google_project_service.sqladmin,
  ]

  # checkov:skip=CKV_GCP_6:Private instance can accept unencrypted connections
  # checkov:skip=CKV_GCP_110:Don't enable pgAudit
  # checkov:skip=CKV_GCP_111:Don't log SQL statements
  # checkov:skip=CKV2_GCP_13:Don't log SQL statement duration
}

module "netbox-vm" {
  source = "../../../netbox/vm"

  project = var.project

  name = coalesce(var.hostname, var.name)
  zone = var.zone

  role     = "PostgreSQL"
  platform = "Google Cloud"
  site     = var.site
  cluster  = var.cluster

  interface  = "internal"
  ip_address = google_sql_database_instance.main.private_ip_address
}

data "google_compute_default_service_account" "default" {
  project = var.project
}

resource "google_project_iam_member" "compute_default_service_account" {
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${data.google_compute_default_service_account.default.email}"
  project = var.project
}
