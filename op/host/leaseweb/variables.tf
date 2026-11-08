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

variable "read_credentials" {
  type        = bool
  default     = true
  description = <<-EOT
    Read the remote-management (and, without root_password, the root) password
    from the Leaseweb API. Needed when the 1Password item is created or
    replaced; set false for hosts whose item already exists.
  EOT
}

variable "root_password" {
  type        = string
  default     = null
  sensitive   = true
  description = "Root password the host was installed with (os_root_password of leaseweb/server/installation). null reads it from the Leaseweb API."
}
