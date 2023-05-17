output "user" {
  value = google_sql_user.main
}

output "secret" {
  value = google_secret_manager_secret.user
}
