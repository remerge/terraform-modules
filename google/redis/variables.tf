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
  default = "redis"
}

variable "network" {
  type = string
}

variable "redis_version" {
  type    = string
  default = "REDIS_7_2"
}

variable "memory" {
  type    = number
  default = 1
}

variable "persistence_mode" {
  type    = string
  default = "DISABLED"
}

variable "persistence_period" {
  type    = string
  default = null
}

variable "maxmemory_policy" {
  type    = string
  default = "volatile-lru"
}
