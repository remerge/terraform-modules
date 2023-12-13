output "database" {
  value = google_sql_database.main
}

output "user" {
  value = google_sql_user.main
}

output "password" {
  value = random_password.user.result
}
