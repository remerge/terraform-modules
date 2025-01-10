variable "server_id" {
  type = string
}

variable "hostname" {
  type = string
}

variable "raid_type" {
  type    = string
  default = "HW"
}

variable "internal_mac" {
  type = string
}

variable "internal_ip" {
  type = string
}

variable "internal_gateway" {
  type    = string
  default = "10.32.0.1"
}

variable "internal_dns" {
  type    = string
  default = "10.164.15.230"
}

variable "enrollment_token" {
  type      = string
  sensitive = true
}
