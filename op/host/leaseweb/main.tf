# The Leaseweb credentials API fails intermittently, and every read is a chance
# to fail the whole plan. Credentials are therefore read only when the caller
# asks for them (new host, new equipment ID); otherwise the 1Password item keeps
# the passwords it was written with (see ignore_changes below). After a
# reinstall, replace the item with read_credentials set to pick up the new
# root password.
data "leaseweb_dedicated_server_credential" "main" {
  count = var.read_credentials ? 1 : 0

  dedicated_server_id = var.leaseweb_id
  type                = "REMOTE_MANAGEMENT"
  username            = "admin"
}

data "leaseweb_dedicated_server_credential" "root" {
  count = var.read_credentials ? 1 : 0

  dedicated_server_id = var.leaseweb_id
  type                = "OPERATING_SYSTEM"
  username            = "root"
}

locals {
  admin_password = one(data.leaseweb_dedicated_server_credential.main[*].password)
  root_password  = one(data.leaseweb_dedicated_server_credential.root[*].password)
}

# New hardware (a new equipment ID) comes with new credentials, so the item is
# written again from fresh ones.
resource "terraform_data" "equipment" {
  input = var.leaseweb_id
}

resource "onepassword_item" "gc" {
  vault    = var.vault
  title    = var.hostname
  category = "login"

  username = "admin"
  password = local.admin_password
  url      = "https://${var.remote_management_ip}"

  section {
    label = "netbox"

    field {
      label = "id"
      type  = "STRING"
      value = var.netbox_id
    }

    field {
      label = "url"
      type  = "STRING"
      value = "http://netbox.rmge.net/dcim/devices/${var.netbox_id}/"
    }
  }

  section {
    label = "leaseweb"

    field {
      label = "id"
      type  = "STRING"
      value = var.leaseweb_id
    }

    field {
      label = "url"
      type  = "STRING"
      value = "https://secure.leaseweb.com/bare-metals/servers/${var.leaseweb_id}"
    }
  }

  section {
    label = "idrac"

    field {
      label = "ip"
      type  = "STRING"
      value = var.remote_management_ip
    }

    field {
      label = "username"
      type  = "STRING"
      value = "admin"
    }

    field {
      label = "password"
      type  = "CONCEALED"
      value = local.admin_password
    }
  }

  section {
    label = "os"

    field {
      label = "username"
      type  = "STRING"
      value = "root"
    }

    field {
      label = "password"
      type  = "CONCEALED"
      value = local.root_password
    }
  }

  lifecycle {
    # Both passwords are written once. The paths are indexes: section 2 is
    # "idrac" (field 2 "password"), section 3 is "os" (field 1 "password").
    # Keep them in sync with the block order above.
    ignore_changes = [
      password,
      section[2].field[2].value,
      section[3].field[1].value,
    ]
    replace_triggered_by = [terraform_data.equipment]
  }
}
