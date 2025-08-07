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
    "Core Platform Team",
    "Data Platform Team",
  ]
}
