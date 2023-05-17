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
  type    = number
  default = null
}

variable "site" {
  type    = number
  default = null
}

variable "cluster" {
  type    = number
  default = null
}

variable "platform" {
  type    = number
  default = null
}

variable "tags" {
  type    = list(string)
  default = []
}
