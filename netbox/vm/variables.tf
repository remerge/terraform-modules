variable "name" {
  type = string
}

variable "ip_address" {
  type    = string
  default = null
}

variable "interface" {
  type    = string
  default = null
}

variable "role" {
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

variable "platform" {
  type    = any
  default = null
}

variable "tags" {
  type    = list(string)
  default = []
}
