variable "project" {
  type = string
}

variable "name" {
  type = string
}

variable "zone" {
  type = any
}

variable "network" {
  type = string
}

variable "targets" {
  type = list(string)
}
