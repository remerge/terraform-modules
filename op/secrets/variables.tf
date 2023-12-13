variable "workspace" {
  type = string
}

variable "prefix" {
  type = string
}

variable "tags" {
  type    = list(string)
  default = []
}

variable "secrets" {
  type = map(string)
}
