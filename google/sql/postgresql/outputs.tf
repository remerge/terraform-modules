output "instance" {
  value = google_sql_database_instance.main
}

output "root_pwd" {
  value = random_password.root.result

}
