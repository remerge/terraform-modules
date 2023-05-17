variable "name" {
  type = string
}

variable "template" {
  type = any
}

variable "machine_type" {
  type    = string
  default = "n2d-standard-2"
}

variable "image" {
  type = string
}

variable "env" {
  type    = map(any)
  default = {}
}

variable "volumes" {
  type = map(object({
    type = optional(string, "pd-ssd")
    size = optional(number, 10)
    path = string
  }))
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
