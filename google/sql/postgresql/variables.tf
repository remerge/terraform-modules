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

variable "name" {
  type    = string
  default = "postgres"
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
