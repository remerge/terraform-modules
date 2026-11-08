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
    Read the remote-management and root passwords from the Leaseweb API.
    Needed when the 1Password item is created or replaced; set false for
    hosts whose item already exists.
  EOT
}
