output "instance" {
  value = google_compute_instance_from_template.main
}

output "interface" {
  value = google_compute_instance_from_template.main.network_interface[0]
}
