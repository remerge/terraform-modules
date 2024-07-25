variable "project" {
  type = string
}

variable "name" {
  type = string
}

variable "domain" {
  type = string
}

variable "apex_record" {
  type    = list(string)
  default = []
}

variable "dns_records" {
  type    = map(list(string))
  default = {}
}

variable "legacy_zone_name" {
  type    = string
  default = null
}
