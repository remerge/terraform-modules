variable "project" {
  type = string
}

variable "name" {
  type = string
}

variable "type" {
  type    = string
  default = "Google Compute Engine"
}

variable "site" {
  type    = string
  default = null
}
