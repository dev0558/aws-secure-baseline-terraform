output "break_glass_role_arn" {
  value = module.iam_baseline.break_glass_role_arn
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "permission_set_arns" {
  value = module.identity_center.permission_set_arns
}

output "group_ids" {
  value = module.identity_center.group_ids
}

output "cloudtrail_bucket_name" {
  value = module.logging.cloudtrail_bucket_name
}

output "cloudtrail_arn" {
  value = module.logging.cloudtrail_arn
}

output "guardduty_detector_id" {
  value = module.detection.guardduty_detector_id
}

output "security_hub_arn" {
  value = module.detection.security_hub_arn
}

output "vpc_id" {
  value = module.network.vpc_id
}

output "vpc_cidr" {
  value = module.network.vpc_cidr
}

output "private_subnet_ids" {
  value = module.network.private_subnet_ids
}

output "nat_gateway_ips" {
  value = module.network.nat_gateway_ips
}
