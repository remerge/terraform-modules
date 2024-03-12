variable "server_id" {
  type = string
}

variable "hostname" {
  type = string
}

variable "internal_mac" {
  type = string
}

variable "internal_ip" {
  type = string
}

variable "enrollment_token" {
  type      = string
  sensitive = true
}
