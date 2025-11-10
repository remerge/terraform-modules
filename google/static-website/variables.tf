variable "project" {
  description = "The project ID to host the site in."
  type        = string
}

# Load Balancer
variable "lb_address" {
  description = "Load Balancer IP address"
  type        = string
}

variable "certificate_map" {
  description = "Certificate map resource"
  type        = string
}

# Domain & DNS
variable "domains_project" {
  description = "The name of the Google Cloud project where DNS zones are managed."
  type        = string
  default     = "domains-84b3"
}

variable "name" {
  description = "The name of the website and the Cloud Storage bucket to create (e.g. static.foo.com)."
  type        = string
}

variable "dns_managed_zone_name" {
  description = "The name of the Cloud DNS Managed Zone in which to create the DNS CNAME Record specified in var.name."
  type        = string
  default     = "remerge-io"
}

variable "dns_record_ttl" {
  description = "The time-to-live for the site CNAME record set (seconds)"
  type        = number
  default     = 300
}

# Google Cloud Storage bucket
variable "bucket_name" {
  description = "Website bucket name"
  type        = string
  default     = ""
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

variable "enable_cdn" {
  description = "Set to `true` to enable cdn on website backend bucket."
  type        = bool
  default     = true
}

# Workload Identity Federation
variable "identity_pool" {
  description = "Google Cloud Workload Identity Pool"
  type        = string
  default     = "projects/654112073299/locations/global/workloadIdentityPools/github-actions-pool"
}

variable "identity_organization" {
  description = "GitHub Workload Identity Organization"
  type        = string
  default     = "remerge"
}

variable "identity_repository" {
  description = "GitHub Workload Identity Repository"
  type        = string
}
