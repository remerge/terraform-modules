output "host" {
  value = google_redis_instance.main.host
}

output "auth" {
  value     = google_redis_instance.main.auth_string
  sensitive = true
}
