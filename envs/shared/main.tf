module "iam_baseline" {
  source = "../../modules/iam_baseline"

  break_glass_trusted_principal_arn = var.break_glass_trusted_principal_arn
}

module "identity_center" {
  source = "../../modules/identity_center"

  instance_arn      = var.sso_instance_arn
  identity_store_id = var.sso_identity_store_id
  target_account_id = data.aws_caller_identity.current.account_id
}

module "logging" {
  source = "../../modules/logging"
}

module "detection" {
  source = "../../modules/detection"
}

module "network" {
  source = "../../modules/network"
}
