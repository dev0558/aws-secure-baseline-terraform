resource "aws_identitystore_group" "admins" {
  identity_store_id = var.identity_store_id
  display_name      = "landing_zone_admins"
  description       = "Full administrators of the landing zone"
}

resource "aws_identitystore_group" "developers" {
  identity_store_id = var.identity_store_id
  display_name      = "landing_zone_developers"
  description       = "Developers with scoped access"
}

resource "aws_identitystore_group" "read_only" {
  identity_store_id = var.identity_store_id
  display_name      = "landing_zone_read_only"
  description       = "Read-only auditors"
}

resource "aws_identitystore_group" "billing" {
  identity_store_id = var.identity_store_id
  display_name      = "landing_zone_billing"
  description       = "Billing and cost viewers"
}
