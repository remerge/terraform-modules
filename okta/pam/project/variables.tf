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
