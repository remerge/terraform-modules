variable "project" {
  type = string
}

variable "name" {
  type = string
}

variable "hostname" {
  type    = string
  default = null
}

variable "zone" {
  type    = any
  default = null
}

variable "model" {
  type = string
}

variable "role" {
  type    = string
  default = "Other"
}

variable "platform" {
  type    = string
  default = "Other"
}

variable "site" {
  type    = any
  default = null
}

variable "cluster" {
  type    = any
  default = null
}

variable "asset_tag" {
  type    = string
  default = null
}

variable "tags" {
  type    = list(string)
  default = null
}

variable "interface" {
  type    = string
  default = null
}

variable "interface_type" {
  type    = string
  default = "10gbase-t"
}

variable "ip_address" {
  type    = string
  default = null
}

variable "rack" {
  description = <<-EOT
    Rack placement of the device. The rack is looked up in NetBox by its
    facility ID within the device's site (e.g. the rack name reported by the
    Leaseweb API). Placement stays empty when no matching rack exists in NetBox.
  EOT
  type = object({
    facility_id = string
    position    = number
    face        = optional(string, "front")
  })
  default = null
}
