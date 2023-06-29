variable "project" {
  type    = string
  default = null
}

variable "region" {
  type    = string
  default = null
}

variable "name" {
  type = string
}

variable "hostname" {
  type    = string
  default = null
}

variable "domain" {
  type    = any
  default = null
}

variable "site" {
  type    = any
  default = null
}

variable "cluster" {
  type    = any
  default = null
}

variable "database_version" {
  type    = string
  default = "POSTGRES_15"
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
