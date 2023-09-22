resource "google_sql_database" "main" {
  project  = var.project
  instance = var.instance
  name     = var.name
}

resource "random_password" "user" {
  length           = 32
  special          = true
  override_special = "_%@"
}

resource "google_sql_user" "main" {
  project  = var.project
  instance = var.instance
  name     = var.name
  password = random_password.user.result
}

resource "google_secret_manager_secret" "user" {
  project   = var.project
  secret_id = "sql-${var.instance}-user-${var.name}"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "user" {
  secret      = google_secret_manager_secret.user.name
  secret_data = random_password.user.result
}
