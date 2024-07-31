output "backend_bucket" {
  value = google_compute_backend_bucket.static
}

output "name" {
  value = var.name
}

output "bucket_name" {
  value = local.bucket_name
}
