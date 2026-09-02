output "network_ip" {
  value = google_compute_instance_from_template.main.network_interface[0].network_ip
}
