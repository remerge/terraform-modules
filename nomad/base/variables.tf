variable "cluster" {
  type        = string
  description = "cluster name"
}

variable "workspace" {
  type = string
}

variable "auth_max_token_ttl" {
  type    = string
  default = "24h0m0s"
}

variable "okta_discovery_url" {
  type    = string
  default = "https://remerge.okta.com"
}

variable "onepassword_secrets_vault_name" {
  type    = string
  default = "secrets"
}
