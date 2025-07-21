variable "workspace" {
  type = string
}

variable "project" {
  type = string
}

variable "region" {
  type    = string
  default = null
}

variable "database_version" {
  type    = string
  default = "POSTGRES_17"
}

variable "tier" {
  type    = string
  default = "db-f1-micro"
}

variable "network" {
  type = string
}

variable "backup" {
  type = object({
    location = optional(string, "eu")
  })
  default = {}
}

variable "database_flags" {
  type    = map(any)
  default = {}
}

variable "ipv4_enabled" {
  type    = bool
  default = false
}

variable "authorized_networks" {
  description = "List of authorized networks for public access. Each object must have 'name' and 'value' (subnet/CIDR)."
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}
