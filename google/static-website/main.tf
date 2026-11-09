locals {
  name_dashed = replace(var.name, ".", "-")
  bucket_name = var.bucket_name == "" ? local.name_dashed : var.bucket_name
}

resource "google_storage_bucket" "website" {
  # checkov:skip=CKV_GCP_114:Public website
  name                        = local.bucket_name
  project                     = var.project
  location                    = "EU"
  storage_class               = "STANDARD"
  public_access_prevention    = "inherited"
  uniform_bucket_level_access = true
  force_destroy               = false

  labels = {
    name = replace(local.bucket_name, ".", "-")
  }

  versioning {
    enabled = false
  }

  hierarchical_namespace {
    enabled = false
  }

  website {
    main_page_suffix = var.index_page
    not_found_page   = var.not_found_page
  }
}

resource "google_storage_bucket_iam_binding" "admins" {
  bucket = google_storage_bucket.website.name
  role   = "roles/storage.objectAdmin"
  members = [
    "serviceAccount:github-actions@github-6d1f.iam.gserviceaccount.com",
    "principalSet://iam.googleapis.com/${var.identity_pool}/attribute.repository/${var.identity_organization}/${var.identity_repository}",
  ]
}

resource "google_compute_backend_bucket" "static" {
  project     = var.project
  name        = local.bucket_name
  bucket_name = google_storage_bucket.website.name
  enable_cdn  = var.enable_cdn
}

# https://cloud.google.com/storage/docs/access-control/making-data-public#buckets
resource "google_storage_bucket_iam_member" "default" {
  bucket = google_storage_bucket.website.name
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
