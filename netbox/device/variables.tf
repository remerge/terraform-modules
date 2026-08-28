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
  description = "Device type model name; ignored when device_type_id is set."
  type        = string
  default     = null
}

variable "device_type_id" {
  type    = number
  default = null
}

variable "role" {
  description = "Device role name; ignored when role_id is set."
  type        = string
  default     = "Other"
}

variable "role_id" {
  type    = number
  default = null
}

variable "platform" {
  description = "Platform name; ignored when platform_id is set."
  type        = string
  default     = "Other"
}

variable "platform_id" {
  type    = number
  default = null
}

variable "site" {
  description = "Site name; ignored when site_id is set."
  type        = any
  default     = null
}

variable "site_id" {
  type    = number
  default = null
}

variable "cluster" {
  description = "Cluster name; ignored when cluster_id is set."
  type        = any
  default     = null
}

variable "cluster_id" {
  type    = number
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

variable "rack_id" {
  description = "NetBox rack ID. Placement stays empty when null."
  type        = number
  default     = null
}

variable "location_id" {
  description = "NetBox location ID of the rack (NetBox requires it to match the rack's location)."
  type        = number
  default     = null
}

variable "rack" {
  description = "Rack placement of the device within var.rack_id."
  type = object({
    position = number
    face     = optional(string, "front")
  })
  default = null
}
