output "permission_set_arns" {
  value = {
    admin      = aws_ssoadmin_permission_set.admin.arn
    power_user = aws_ssoadmin_permission_set.power_user.arn
    read_only  = aws_ssoadmin_permission_set.read_only.arn
    billing    = aws_ssoadmin_permission_set.billing.arn
    developer  = aws_ssoadmin_permission_set.developer.arn
  }
}

output "group_ids" {
  value = {
    admins     = aws_identitystore_group.admins.group_id
    developers = aws_identitystore_group.developers.group_id
    read_only  = aws_identitystore_group.read_only.group_id
    billing    = aws_identitystore_group.billing.group_id
  }
}
