variable "project" {
  type = string
}

variable "name" {
  type = string
}

variable "type" {
  type    = string
  default = "Google Compute Engine"
}

variable "site" {
  type    = string
  default = null
}

variable "network" {
  type    = string
  default = null
}

variable "domain" {
  type    = string
  default = null
}

variable "dns_name" {
  type    = string
  default = null
}

variable "dns_records" {
  type    = map(list(string))
  default = {}
}

variable "legacy_zone_name" {
  type    = string
  default = null
}
