locals {
  # We have to use dashes instead of dots in the bucket name, because
  # that bucket is not a website
  website_domain_name_dashed = replace(var.website_domain_name, ".", "-")
}

resource "google_compute_backend_bucket" "static" {
  project = var.project

  name        = var.bucket_name == "" ? "${local.website_domain_name_dashed}-bucket" : "${var.bucket_name}"
  bucket_name = module.website.name
  enable_cdn  = var.enable_cdn
}

module "website" {
  source          = "terraform-google-modules/cloud-storage/google"
  version         = "5.0.0"
  project_id      = var.project
  names           = [local.website_domain_name_dashed]
  set_admin_roles = true
  admins          = var.storage_admin
  website = {
    main_page_suffix = var.index_page
    not_found_page   = var.not_found_page
  }
}

# Make bucket public by granting allUsers READER access
resource "google_storage_bucket_iam_member" "default" {
  bucket = module.website.name
  role   = "roles/storage.legacyObjectReader"
  member = "allUsers"
  # checkov:skip=CKV_GCP_28:Public website
}

resource "google_dns_record_set" "cname" {
  depends_on = [module.website]

  project = var.domains_project

  name         = "${var.website_domain_name}."
  managed_zone = var.dns_managed_zone_name
  type         = "A"
  ttl          = var.dns_record_ttl
  rrdatas      = [var.lb_address]
}


output "google_compute_backend_bucket_id" {
  value = google_compute_backend_bucket.static.self_link
}
