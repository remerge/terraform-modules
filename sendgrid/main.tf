resource "sendgrid_api_key" "main" {
  name = var.name
  scopes = [
    "mail.send",
    "2fa_exempt",
    "2fa_required",
    "sender_verification_eligible",
    "sender_verification_legacy",
  ]
}

resource "google_secret_manager_secret" "key" {
  project   = var.project
  secret_id = "sendgrid-key-${var.name}"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "key" {
  secret      = google_secret_manager_secret.key.name
  secret_data = sendgrid_api_key.main.api_key
}

resource "google_secret_manager_secret_iam_member" "key" {
  project   = var.project
  secret_id = google_secret_manager_secret.key.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${data.google_compute_default_service_account.default.email}"
}

data "google_compute_default_service_account" "default" {
  project = var.project
}
