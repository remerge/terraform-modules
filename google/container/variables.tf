variable "name" {
  type = string
}

variable "domain" {
  type    = any
  default = null
}

variable "template" {
  type    = string
  default = null
}

variable "machine_type" {
  type    = string
  default = "n2d-standard-2"
}

variable "disk_image" {
  type    = string
  default = "cos-cloud/cos-stable"
}

variable "disk_size" {
  type    = number
  default = 10
}

variable "volumes" {
  type = map(object({
    type = optional(string, "pd-ssd")
    size = optional(number, 10)
    path = string
  }))
  default = {}
}

variable "image" {
  type = string
}

variable "env" {
  type    = map(any)
  default = {}
}

variable "project" {
  type    = string
  default = null
}

variable "zone" {
  type    = string
  default = null
}
