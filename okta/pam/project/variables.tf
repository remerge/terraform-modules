variable "project" {
  type = string
}

variable "name" {
  type = string
}

variable "groups" {
  type = list(string)
  default = [
    "On-Call Team",
    "Platform Team",
  ]
}

variable "service_account" {
  type    = string
  default = null
}
