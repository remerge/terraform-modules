output "instance" {
  value = google_sql_database_instance.main
}

output "root_password" {
  value = random_password.root.result
}
