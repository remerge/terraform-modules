variable "vault" {
  type = string
}

variable "hostname" {
  type = string
}

variable "remote_management_ip" {
  type = string
}

variable "netbox_id" {
  type = string
}

variable "leaseweb_id" {
  type = string
}

variable "os_root_password" {
  type      = string
  sensitive = true
}
