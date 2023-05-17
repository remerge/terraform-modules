variable "name" {
  type = string
}

variable "ip_address" {
  type    = string
  default = null
}

variable "role_id" {
  type    = number
  default = null
}

variable "site_id" {
  type    = number
  default = null
}

variable "cluster_id" {
  type    = number
  default = null
}

variable "tags" {
  type    = list(string)
  default = []
}
