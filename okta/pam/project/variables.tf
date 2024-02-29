variable "project" {
  type = string
}

variable "name" {
  type = string
}

variable "groups" {
  type = list(string)
  default = [
    "owners",
    "On-Call Team",
    "Platform Team",
  ]
}
