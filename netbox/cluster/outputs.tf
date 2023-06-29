output "name" {
  value = netbox_cluster.main.name
}

output "domain" {
  value = try(google_dns_managed_zone.private[0].name, null)
}

output "domain_name" {
  value = try(google_dns_managed_zone.private[0].description, null)
}

output "dns_name" {
  value = try(google_dns_managed_zone.private[0].dns_name, null)
}
