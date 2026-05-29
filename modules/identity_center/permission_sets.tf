# Administrator
resource "aws_ssoadmin_permission_set" "admin" {
  name             = "AdministratorAccess"
  description      = "Full administrative access. Use sparingly."
  instance_arn     = var.instance_arn
  session_duration = "PT2H"
}

resource "aws_ssoadmin_managed_policy_attachment" "admin" {
  instance_arn       = var.instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  permission_set_arn = aws_ssoadmin_permission_set.admin.arn
}

# Power user
resource "aws_ssoadmin_permission_set" "power_user" {
  name             = "PowerUserAccess"
  description      = "All services except IAM and Organizations"
  instance_arn     = var.instance_arn
  session_duration = "PT4H"
}

resource "aws_ssoadmin_managed_policy_attachment" "power_user" {
  instance_arn       = var.instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
  permission_set_arn = aws_ssoadmin_permission_set.power_user.arn
}

# Read only
resource "aws_ssoadmin_permission_set" "read_only" {
  name             = "ReadOnlyAccess"
  description      = "Read-only access to all AWS services"
  instance_arn     = var.instance_arn
  session_duration = "PT8H"
}

resource "aws_ssoadmin_managed_policy_attachment" "read_only" {
  instance_arn       = var.instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  permission_set_arn = aws_ssoadmin_permission_set.read_only.arn
}

# Billing viewer
resource "aws_ssoadmin_permission_set" "billing" {
  name             = "BillingViewer"
  description      = "View billing and cost management"
  instance_arn     = var.instance_arn
  session_duration = "PT4H"
}

resource "aws_ssoadmin_managed_policy_attachment" "billing" {
  instance_arn       = var.instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/job-function/Billing"
  permission_set_arn = aws_ssoadmin_permission_set.billing.arn
}

# Developer (custom inline policy, scoped)
resource "aws_ssoadmin_permission_set" "developer" {
  name             = "DeveloperAccess"
  description      = "Scoped developer access: compute, storage, observability"
  instance_arn     = var.instance_arn
  session_duration = "PT8H"
}

data "aws_iam_policy_document" "developer" {
  statement {
    sid    = "AllowCommonDeveloperServices"
    effect = "Allow"
    actions = [
      "ec2:*",
      "lambda:*",
      "s3:*",
      "dynamodb:*",
      "cloudwatch:*",
      "logs:*",
      "cloudformation:*",
      "ecr:*",
      "ecs:*",
      "sqs:*",
      "sns:*",
      "iam:PassRole",
      "iam:GetRole",
      "iam:ListRoles"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "DenyDangerousActions"
    effect = "Deny"
    actions = [
      "iam:CreateUser",
      "iam:DeleteUser",
      "iam:CreateAccessKey",
      "iam:DeleteAccessKey",
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:AttachUserPolicy",
      "iam:AttachRolePolicy",
      "iam:PutRolePolicy",
      "iam:PutUserPolicy",
      "organizations:*",
      "account:*",
      "billing:*"
    ]
    resources = ["*"]
  }
}

resource "aws_ssoadmin_permission_set_inline_policy" "developer" {
  instance_arn       = var.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.developer.arn
  inline_policy      = data.aws_iam_policy_document.developer.json
}
