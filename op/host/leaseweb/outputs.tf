output "leaseweb_id" {
  description = "Equipment ID recorded in the 1Password item; callers compare it with the current one to decide read_credentials."
  value       = one([for s in onepassword_item.gc.section : one([for f in s.field : f.value if f.label == "id"]) if s.label == "leaseweb"])
}
