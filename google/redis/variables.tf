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
