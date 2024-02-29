resource "oktapam_project" "default" {
  name = var.name
  # manage user account on servers
  create_server_users = true
}

resource "oktapam_project_group" "default" {
  project_name = oktapam_project.default.name
  server_admin = true
  group_name   = each.value
  for_each     = toset(var.groups)
}

resource "oktapam_server_enrollment_token" "default" {
  description  = "default"
  project_name = oktapam_project.default.name
}
