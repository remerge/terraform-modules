variable "project" {
  type = string
}

variable "name" {
  type = string
}

variable "domain" {
  type = any
}

variable "network" {
  type = any
}

variable "targets" {
  type = list(string)
}
