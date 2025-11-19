data "onepassword_vault" "secrets" {
  name = var.onepassword_secrets_vault_name
}

resource "nomad_namespace" "default" {
  name        = "default"
  description = "Default shared namespace"
}

resource "nomad_namespace" "diverts" {
  name        = "diverts"
  description = "Namespace for diverted deployments"
}

resource "nomad_node_pool" "default" {
  name        = "default"
  description = "Default node pool."
}

data "onepassword_item" "nomad_oidc_client" {
  vault = data.onepassword_vault.secrets.uuid
  title = "nomad_oidc_client"
}

resource "nomad_acl_auth_method" "okta" {
  name           = "Okta"
  type           = "OIDC"
  token_locality = "global"
  max_token_ttl  = var.auth_max_token_ttl
  default        = true

  token_name_format = "$${auth_method_type}-$${auth_method_name}"

  config {
    oidc_discovery_url = var.okta_discovery_url
    oidc_client_id     = data.onepassword_item.nomad_oidc_client.username
    oidc_client_secret = data.onepassword_item.nomad_oidc_client.password
    oidc_scopes        = ["profile", "groups"]

    allowed_redirect_uris = [
      "http://localhost:4649/oidc/callback",
      "http://nomad.service.${var.cluster}.consul:4646/ui/settings/tokens",
      "http://nomad.${var.cluster}.rmge.net/ui/settings/tokens",
    ]

    claim_mappings = {
      first_name = "first_name"
      last_name  = "last_name"
    }

    list_claim_mappings = {
      groups = "groups"
    }
  }
}

resource "nomad_acl_policy" "default" {
  name        = "default"
  description = "Default read-only policy"

  rules_hcl = <<EOT
node {
  policy = "read"
}

namespace "${nomad_namespace.default.name}" {
  policy = "read"
  capabilities = ["alloc-exec", "alloc-lifecycle", "read-fs", "read-logs", "scale-job", "submit-job"]
  variables {
    path "*" {
      capabilities = ["write", "read", "destroy", "list"]
    }
  }
}

namespace "${nomad_namespace.diverts.name}" {
  policy = "write"
  variables {
    path "*" {
      capabilities = ["write", "read", "destroy", "list"]
    }
  }
}
EOT
}

resource "nomad_acl_role" "default" {
  name        = "default"
  description = "Default role for users"

  policy {
    name = nomad_acl_policy.default.name
  }
}

resource "nomad_acl_binding_rule" "default" {
  auth_method = nomad_acl_auth_method.okta.name
  bind_type   = "role"
  bind_name   = nomad_acl_role.default.name
}

resource "nomad_acl_policy" "root" {
  name        = "root"
  description = "Default management policy for operators"

  rules_hcl = <<EOT
node {
  policy = "write"
}

namespace "${nomad_namespace.default.name}" {
  policy = "write"
  variables {
    path "*" {
      capabilities = ["write", "read", "destroy", "list"]
    }
  }
}

namespace "${nomad_namespace.diverts.name}" {
  policy = "write"
  variables {
    path "*" {
      capabilities = ["write", "read", "destroy", "list"]
    }
  }
}
EOT
}

resource "nomad_acl_role" "root" {
  name        = "root"
  description = "Default role for operators"

  policy {
    name = nomad_acl_policy.root.name
  }
}

moved {
  from = nomad_acl_binding_rule.platform
  to   = nomad_acl_binding_rule.core
}

resource "nomad_acl_binding_rule" "core" {
  auth_method = nomad_acl_auth_method.okta.name
  bind_type   = "role"
  bind_name   = nomad_acl_role.root.name
  selector    = "\"Core Platform Team\" in list.groups"
}

resource "nomad_acl_binding_rule" "data" {
  auth_method = nomad_acl_auth_method.okta.name
  bind_type   = "role"
  bind_name   = nomad_acl_role.root.name
  selector    = "\"Data Platform Team\" in list.groups"
}

resource "nomad_acl_binding_rule" "oncall" {
  auth_method = nomad_acl_auth_method.okta.name
  bind_type   = "role"
  bind_name   = nomad_acl_role.root.name
  selector    = "\"On-Call Team\" in list.groups"
}

resource "nomad_acl_policy" "github_actions" {
  name        = "github-actions"
  description = "Policy for Github Actions"

  rules_hcl = <<EOT
node {
  policy = "write"
}

agent {
  policy = "write"
}

operator {
  policy = "write"
}

plugin {
  policy = "list"
}

host_volume "*" {
  policy = "write"
}

namespace "default" {
  capabilities = ["submit-job","list-jobs","scale-job","dispatch-job"]
  policy = "read"
   variables {
    path "*" {
      capabilities = ["write", "read", "destroy", "list"]
    }
  }
}
EOT
}

resource "nomad_acl_token" "github_actions" {
  name     = "Github Actions"
  type     = "client"
  policies = [nomad_acl_policy.github_actions.name]
  global   = true
}

module "op_github_actions" {
  source    = "../../op/secrets"
  workspace = var.workspace
  prefix    = "nomad"
  secrets = {
    "token_${var.cluster}_github_actions" = nomad_acl_token.github_actions.secret_id
  }
}
