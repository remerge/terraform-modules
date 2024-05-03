variable "project" {
  description = "The project ID to host the site in."
  type        = string
}

variable "storage_admin" {
  description = "Bucket storage admin"
  type        = string
}

variable "lb_address" {
  description = "loadbalancer IP address"
  type        = string
}

variable "certificate_map" {
  description = "Certificate map resource"
  type        = string
}

variable "domains_project" {
  description = "Domains GCP project"
  type        = string
  default     = "domains-84b3"
}

variable "workspace_name" {
  description = "project workspace name"
  type        = string
}

variable "website_domain_name" {
  description = "The name of the website and the Cloud Storage bucket to create (e.g. static.foo.com)."
  type        = string
}

variable "dns_managed_zone_name" {
  description = "The name of the Cloud DNS Managed Zone in which to create the DNS CNAME Record specified in var.website_domain_name. Only used if var.create_dns_entry is true."
  type        = any
}

variable "website_storage_class" {
  description = "Storage class of the bucket that will store the static website"
  type        = string
  default     = "MULTI_REGIONAL"
}

variable "ssl_certificate" {
  description = "SSL certificate self_link. Required if 'enable_ssl' is 'true'."
  type        = string
  default     = ""
}

variable "enable_cdn" {
  description = "Set to `true` to enable cdn on website backend bucket."
  type        = bool
  default     = true
}

variable "index_page" {
  description = "Bucket's directory index"
  type        = string
  default     = "index.html"
}

variable "not_found_page" {
  description = "The custom object to return when a requested resource is not found"
  type        = string
  default     = "index.html"
}

variable "dns_record_ttl" {
  description = "The time-to-live for the site CNAME record set (seconds)"
  type        = number
  default     = 300
}

variable "bucket_name" {
  description = "Website bucket name"
  type        = string
  default     = ""
}
