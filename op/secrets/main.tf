data "onepassword_vault" "secrets" {
  name = "secrets"
}

resource "onepassword_item" "secrets" {
  for_each = var.secrets
  vault    = data.onepassword_vault.secrets.id
  title    = "${var.prefix}_${each.key}"
  category = "password"
  password = each.value
  tags = concat(var.tags, [
    "prefix:${var.prefix}",
    "workspace:${var.workspace}",
  ])
}
