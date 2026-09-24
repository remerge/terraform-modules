variable "name" {
  description = "Client name, e.g. \"admin.remerge.io\"."
  type        = string
}

variable "type" {
  description = <<-EOT
    Application type: "spa" for a single-page app (public client, no secret) or
    "regular_web" for a server-side web app (confidential client with a secret).
  EOT
  type        = string
  default     = "spa"

  validation {
    condition     = contains(["spa", "regular_web"], var.type)
    error_message = "type must be \"spa\" or \"regular_web\"."
  }
}

variable "urls" {
  description = <<-EOT
    Allowed callback URLs (production + local dev). Also the default for
    `allowed_logout_urls`, and for `web_origins` on a SPA.
  EOT
  type        = list(string)
}

variable "allowed_logout_urls" {
  description = <<-EOT
    Allowed logout URLs. Defaults to `urls`. Set to [] for a client with no
    logout page on our side.
  EOT
  type        = list(string)
  default     = null
}

variable "web_origins" {
  description = <<-EOT
    Allowed web origins. Defaults to `urls` for a SPA and to none for a web app.
    Set to [] for a SPA that never does silent auth in a browser (Auth0 wants
    `scheme://host` here, no path).
  EOT
  type        = list(string)
  default     = null
}

variable "is_first_party" {
  description = <<-EOT
    Whether the client is first-party. False creates a strict third-party
    client: Auth0 rejects `connections` for it and logs users in only through
    an Organization that allows third-party clients. Clients we register
    ourselves stay first-party, even when someone else runs them.
  EOT
  type        = bool
  default     = true
}

variable "grants" {
  description = <<-EOT
    API grants, keyed by audience (resource-server identifier), each mapping to
    the scopes granted for that audience (empty list = audience access with no
    specific scopes). Each entry creates one auth0_client_grant with
    subject_type "user". The default (empty map) creates no grant.
  EOT
  type        = map(list(string))
  default     = {}
}

variable "connections" {
  description = <<-EOT
    Connections to enable for this client, keyed by a caller-chosen stable label
    mapping to the connection ID (e.g. { okta = auth0_connection.okta.id }).
    Each entry creates one auth0_connection_client. The label is the map key
    (rather than the ID) so it is known at plan time even when the connection ID
    is only known after apply. The default (empty map) enables no connections.
  EOT
  type        = map(string)
  default     = {}
}
