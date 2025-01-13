variable "project" {
  type = string
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

variable "zone" {
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

variable "network" {
  type = string
}

variable "version" {
  type    = string
  default = "REDIS_7_2"
}

variable "memory" {
  type    = number
  default = 2
}

variable "persistence_mode" {
  type    = string
  default = "RDB"
}

variable "persistence_period" {
  type    = string
  default = "ONE_HOUR"
}
