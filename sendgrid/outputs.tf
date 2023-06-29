output "key" {
  value = sendgrid_api_key.main.api_key
}

output "secret" {
  value = google_secret_manager_secret.key
}
