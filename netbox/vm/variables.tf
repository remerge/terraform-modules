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

variable "domain" {
  type    = string
  default = null
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

variable "tags" {
  type    = list(string)
  default = []
}

variable "interface" {
  type    = string
  default = null
}

variable "ip_address" {
  type    = string
  default = null
}
