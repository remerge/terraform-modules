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

variable "ip_address" {
  type    = string
  default = null
}
