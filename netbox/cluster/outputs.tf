output "name" {
  value = netbox_cluster.main.name
}

output "zone" {
  value = try(google_dns_managed_zone.private[0], null)
}
