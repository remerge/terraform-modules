# Hardened defaults for a Remerge Auth0 application that logs users in: a
# single-page app (public client, `type = "spa"`) or a server-side web app
# (confidential client, `type = "regular_web"`). Every hardening value here is
# intentionally identical across all clients of both types; per-app variation
# is limited to the name, URLs, grants and connections.
locals {
  spa = var.type == "spa"
}

resource "auth0_client" "this" {
  name = var.name

  # First-party: we register every client ourselves. A third-party client is
  # created in strict mode, which cannot be enabled on a connection and logs
  # users in only through an Organization prompt.
  is_first_party     = true
  app_type           = var.type
  oidc_conformant    = true
  organization_usage = "allow"

  callbacks           = var.urls
  allowed_logout_urls = var.allowed_logout_urls != null ? var.allowed_logout_urls : var.urls

  # SPAs do silent auth from their own origin; a server-side web app does not,
  # so it gets no web origins unless the caller sets them.
  web_origins = var.web_origins != null || !local.spa ? var.web_origins : var.urls

  # Authorization code flow only (with PKCE for SPAs); implicit is a legacy
  # grant with weaker security and no refresh-token support.
  grant_types = [
    "authorization_code",
    "refresh_token",
  ]

  # RS256 asymmetric signing: ID tokens are verified against the tenant JWKS
  # (a public client has no shared secret for HS256). Pinning it prevents drift
  # to the Auth0 Management API HS256 default.
  jwt_configuration {
    alg = "RS256"
  }

  # Rotating + expiring refresh tokens: a leaked token is only valid until the
  # next use. Lifetimes match the tenant session bounds (12h absolute / 2h
  # idle) so the client can never outlive the upstream Okta session it was
  # minted from.
  refresh_token {
    rotation_type                = "rotating"
    expiration_type              = "expiring"
    token_lifetime               = 43200 # 12h absolute — matches session_lifetime
    idle_token_lifetime          = 7200  # 2h idle      — matches idle_session_lifetime
    leeway                       = 30
    infinite_token_lifetime      = false
    infinite_idle_token_lifetime = false
  }
}

# SPAs are public clients without a secret; a web app authenticates the token
# exchange with its client secret, sent in the request body.
resource "auth0_client_credentials" "this" {
  client_id             = auth0_client.this.client_id
  authentication_method = local.spa ? "none" : "client_secret_post"
}

# Optional API grants: authorize this client (acting for a user subject) to
# request tokens for one or more resource-server audiences. Keyed by audience
# identifier so each grant's state address is stable and order-independent.
resource "auth0_client_grant" "this" {
  for_each = var.grants

  client_id    = auth0_client.this.client_id
  audience     = each.key
  scopes       = each.value
  subject_type = "user"
}

# Enable this client on the given connections (e.g. the okta SSO connection).
# Keyed by a caller-chosen label so the state address is stable and known at
# plan time even though the connection ID is computed. Non-authoritative: it
# never touches the connection's other enabled clients.
resource "auth0_connection_client" "this" {
  for_each = var.connections

  connection_id = each.value
  client_id     = auth0_client.this.client_id
}
