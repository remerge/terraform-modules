resource "onepassword_item" "gc" {
  vault    = var.vault
  title    = var.hostname
  category = "login"

  username = "admin"
  password = var.remote_management_password
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
      value = var.remote_management_password
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
