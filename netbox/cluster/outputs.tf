output "name" {
  value = netbox_cluster.main.name
}

output "domain" {
  value = google_dns_managed_zone.private
}
