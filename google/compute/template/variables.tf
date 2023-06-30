variable "project" {
  type = string
}

variable "subnetwork" {
  type = string
}

variable "subnetwork_project" {
  type    = string
  default = "network-6f9a"
}

variable "service_account" {
  type    = string
  default = null
}
