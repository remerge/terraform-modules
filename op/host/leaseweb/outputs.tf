output "leaseweb_id" {
  description = "Equipment ID recorded in the 1Password item; callers compare it with the current one to decide read_credentials."
  # The section list is sensitive as a whole because of the password fields;
  # the equipment ID itself is not secret.
  value = nonsensitive(one([for s in onepassword_item.gc.section : one([for f in s.field : f.value if f.label == "id"]) if s.label == "leaseweb"]))
}
