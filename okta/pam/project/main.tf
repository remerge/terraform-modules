resource "oktapam_project" "default" {
  name = var.name
  # manage user account on servers
  create_server_users = true
}

resource "oktapam_project_group" "default" {
  project_name = oktapam_project.default.name
  server_admin = true
  group_name   = each.value
  for_each     = toset(var.groups)
}

resource "oktapam_server_enrollment_token" "default" {
  description  = "default"
  project_name = oktapam_project.default.name
}

resource "google_secret_manager_secret" "okta_enrollment_token" {
  secret_id = "okta-enrollment-token"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "okta_enrollment_token" {
  secret      = google_secret_manager_secret.okta_enrollment_token.id
  secret_data = oktapam_server_enrollment_token.default.token
}

data "google_compute_default_service_account" "default" {}

locals {
  service_account = coalesce(var.service_account, data.google_compute_default_service_account.default.email)
}

resource "google_secret_manager_secret_iam_member" "okta_enrollment_token" {
  secret_id = google_secret_manager_secret.okta_enrollment_token.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${local.service_account}"
}
