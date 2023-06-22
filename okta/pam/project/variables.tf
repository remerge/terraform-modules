variable "name" {
  type = string
}

variable "groups" {
  type = list(string)
  default = [
    "Core Platform Team",
    "Data Platform Team",
    "On-Call Team",
  ]
}
