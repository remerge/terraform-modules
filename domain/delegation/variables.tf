variable "project" {
  type = string
}

variable "name" {
  type = string
}

variable "domain" {
  type = string
}

variable "dns_records" {
  type    = map(list(string))
  default = {}
}

variable "legacy_zone_name" {
  type    = string
  default = null
}
