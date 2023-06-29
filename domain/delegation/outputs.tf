output "zone" {
  value = {
    id      = google_dns_managed_zone.public.id
    name    = google_dns_managed_zone.public.dns_name
    servers = google_dns_managed_zone.public.name_servers
    keys    = data.google_dns_keys.public
  }
}
