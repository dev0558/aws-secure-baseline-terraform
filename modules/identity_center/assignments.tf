resource "aws_ssoadmin_account_assignment" "admins" {
  instance_arn       = var.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.admin.arn
  principal_id       = aws_identitystore_group.admins.group_id
  principal_type     = "GROUP"
  target_id          = var.target_account_id
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "developers" {
  instance_arn       = var.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.developer.arn
  principal_id       = aws_identitystore_group.developers.group_id
  principal_type     = "GROUP"
  target_id          = var.target_account_id
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "read_only" {
  instance_arn       = var.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.read_only.arn
  principal_id       = aws_identitystore_group.read_only.group_id
  principal_type     = "GROUP"
  target_id          = var.target_account_id
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "billing" {
  instance_arn       = var.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.billing.arn
  principal_id       = aws_identitystore_group.billing.group_id
  principal_type     = "GROUP"
  target_id          = var.target_account_id
  target_type        = "AWS_ACCOUNT"
}
