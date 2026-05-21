output "instance" {
  value     = google_redis_instance.main
  sensitive = true
}
