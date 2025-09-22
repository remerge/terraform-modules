resource "sendgrid_api_key" "main" {
  name = var.name
  scopes = [
    "mail.send",
    "2fa_required",
    "sender_verification_eligible",
    "sender_verification_legacy",
  ]
}
