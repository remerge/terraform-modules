locals {
  name_dashed = replace(var.name, ".", "-")
  bucket_name = var.bucket_name == "" ? local.name_dashed : var.bucket_name
}

# Keyed by bucket name so that existing state moves over unchanged: a moved
# block cannot name a computed instance key, but it can move a whole resource.
resource "google_storage_bucket" "website" {
  # checkov:skip=CKV_GCP_114:Public website
  for_each = toset([local.bucket_name])

  name                        = each.key
  project                     = var.project
  location                    = "EU"
  storage_class               = "STANDARD"
  public_access_prevention    = "inherited"
  uniform_bucket_level_access = true
  force_destroy               = false

  labels = {
    name = replace(each.key, ".", "-")
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
  for_each = google_storage_bucket.website

  bucket = each.value.name
  role   = "roles/storage.objectAdmin"
  members = [
    "serviceAccount:github-actions@github-6d1f.iam.gserviceaccount.com",
    "principalSet://iam.googleapis.com/${var.identity_pool}/attribute.repository/${var.identity_organization}/${var.identity_repository}",
  ]
}

moved {
  from = module.website.google_storage_bucket.buckets
  to   = google_storage_bucket.website
}

moved {
  from = module.website.google_storage_bucket_iam_binding.admins
  to   = google_storage_bucket_iam_binding.admins
}

resource "google_compute_backend_bucket" "static" {
  project     = var.project
  name        = local.bucket_name
  bucket_name = google_storage_bucket.website[local.bucket_name].name
  enable_cdn  = var.enable_cdn
}

# https://cloud.google.com/storage/docs/access-control/making-data-public#buckets
resource "google_storage_bucket_iam_member" "default" {
  bucket = google_storage_bucket.website[local.bucket_name].name
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
