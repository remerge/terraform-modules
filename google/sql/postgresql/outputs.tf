output "instance" {
  value = google_sql_database_instance.main.name
}

output "first_ip" {
  value = google_sql_database_instance.main.first_ip_address
}

output "private_ip" {
  value = google_sql_database_instance.main.private_ip_address
}

output "public_ip" {
  value = google_sql_database_instance.main.public_ip_address
}

output "root_password" {
  value     = google_sql_database_instance.main.root_password
  sensitive = true
}
