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
