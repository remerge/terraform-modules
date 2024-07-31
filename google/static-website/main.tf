locals {
  name_dashed = replace(var.name, ".", "-")
  bucket_name = var.bucket_name == "" ? local.name_dashed : var.bucket_name
}

module "website" {
  source  = "terraform-google-modules/cloud-storage/google"
  version = "6.0.0"

  project_id = var.project
  names = [
    local.bucket_name,
  ]

  set_admin_roles = true
  admins = [
    "serviceAccount:github-actions@github-actions-runner-aef2.iam.gserviceaccount.com",
    "principalSet://iam.googleapis.com/${var.identity_pool}/attribute.repository/${var.identity_organization}/${var.identity_repository}",
  ]

  website = {
    main_page_suffix = var.index_page
    not_found_page   = var.not_found_page
  }
}

resource "google_compute_backend_bucket" "static" {
  project     = var.project
  name        = local.bucket_name
  bucket_name = module.website.name
  enable_cdn  = var.enable_cdn
}

# https://cloud.google.com/storage/docs/access-control/making-data-public#buckets
resource "google_storage_bucket_iam_member" "default" {
  bucket = module.website.name
  role   = "roles/storage.legacyObjectReader"
  member = "allUsers"
  # checkov:skip=CKV_GCP_28:Public website
}

resource "google_dns_record_set" "cname" {
  managed_zone = var.dns_managed_zone_name
  project      = var.domains_project
  name         = "${var.name}."
  type         = "A"
  ttl          = var.dns_record_ttl
  rrdatas      = [var.lb_address]
}

output "google_compute_backend_bucket" {
  value = google_compute_backend_bucket.static
}
