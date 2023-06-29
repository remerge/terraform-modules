variable "project" {
  type    = string
  default = null
}

variable "domain" {
  type = any
}

variable "targets" {
  type = list(string)
}
