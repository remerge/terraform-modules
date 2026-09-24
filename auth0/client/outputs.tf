output "client_id" {
  description = "The Auth0-generated client_id."
  value       = auth0_client.this.client_id
}

output "client_secret" {
  description = "The client secret of a web app; null for a SPA, which is a public client."
  value       = local.spa ? null : auth0_client_credentials.this.client_secret
  sensitive   = true
}
