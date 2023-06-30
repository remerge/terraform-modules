variable "project" {
  type = string
}

variable "name" {
  type = string
}

variable "region" {
  type    = string
  default = null
}

variable "network" {
  type = any
}

variable "master_ipv4_cidr_block" {
  type = string
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

variable "machine_type" {
  type    = string
  default = "e2-medium"
}

variable "node_min_count" {
  type    = number
  default = 0
}

variable "node_max_count" {
  type    = number
  default = 1
}
