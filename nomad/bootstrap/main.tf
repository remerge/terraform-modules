provider "terracurl" {
}

resource "terracurl_request" "nomad_bootstrap" {
  name = "nomad-bootstrap"

  url    = "${var.nomad_addr}/v1/acl/bootstrap"
  method = "POST"
  
  # Empty body required for the POST request
  request_body = "{}"
  headers      = {}

  # Nomad returns 200 if successful.
  # Nomad returns 403 if the cluster is ALREADY bootstrapped.
  # We accept both to prevent Terraform from crashing on re-runs.
  response_codes = [200, 403]
}

output "nomad_management_token" {
  description = "The Secret ID of the bootstrapped Nomad management token"
  
  # We use try() because if the response was 403 (already bootstrapped),
  # the JSON body will not contain 'SecretID', which would otherwise cause a crash.
  value = try(
    jsondecode(terracurl_request.nomad_bootstrap.response).SecretID, 
    "CLUSTER_ALREADY_BOOTSTRAPPED_TOKEN_UNKNOWN"
  )
  sensitive = true
}
