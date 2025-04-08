resource "google_project_service" "sqladmin" {
  project = var.project
  service = "sqladmin.googleapis.com"
}

resource "random_password" "root" {
  length           = 32
  special          = true
  override_special = "_%@"
}

resource "google_sql_database_instance" "main" {
  project = var.project
  name    = var.name
  region  = var.region

  database_version = var.database_version
  root_password    = random_password.root.result

  settings {
    tier = var.tier

    ip_configuration {
      private_network = var.network
      ipv4_enabled    = false
      ssl_mode        = "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
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

    dynamic "database_flags" {
      for_each = var.database_flags
      content {
        name  = database_flags.key
        value = database_flags.value
      }
    }

  }

  depends_on = [
    google_project_service.sqladmin,
  ]

  # checkov:skip=CKV_GCP_6:Private instance can accept unencrypted connections
  # checkov:skip=CKV_GCP_79:Accept the version specified by the variable
  # checkov:skip=CKV_GCP_110:Don't enable pgAudit
  # checkov:skip=CKV_GCP_111:Don't log SQL statements
  # checkov:skip=CKV2_GCP_13:Don't log SQL statement duration
}

module "netbox-vm" {
  source = "../../../netbox/vm"

  project = var.project

  name = var.name
  tags = [var.workspace]

  role     = "PostgreSQL"
  platform = "Google Cloud"
  site     = "Google Cloud ${google_sql_database_instance.main.region}"

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
