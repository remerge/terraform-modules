data "leaseweb_dedicated_server_credential" "main" {
  dedicated_server_id = var.leaseweb_id
  type                = "REMOTE_MANAGEMENT"
  username            = "admin"
}

resource "onepassword_item" "gc" {
  vault    = var.vault
  title    = var.hostname
  category = "login"

  username = "admin"
  password = data.leaseweb_dedicated_server_credential.main.password
  url      = "https://${var.remote_management_ip}/restgui/start.html"

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
      value = data.leaseweb_dedicated_server_credential.main.password
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
      value = var.os_root_password
    }
  }
}
