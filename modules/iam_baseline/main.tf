# Account-wide password policy
resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 14
  require_lowercase_characters   = true
  require_uppercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  allow_users_to_change_password = true
  max_password_age               = 90
  password_reuse_prevention      = 24
  hard_expiry                    = false
}

# Trust policy: only the specified principal, only with fresh MFA
data "aws_iam_policy_document" "break_glass_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [var.break_glass_trusted_principal_arn]
    }

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }

    condition {
      test     = "NumericLessThan"
      variable = "aws:MultiFactorAuthAge"
      values   = ["3600"]
    }
  }
}

resource "aws_iam_role" "break_glass_admin" {
  name                 = "break_glass_admin"
  description          = "Emergency full-admin role. MFA required, 1 hour session max."
  assume_role_policy   = data.aws_iam_policy_document.break_glass_trust.json
  max_session_duration = 3600
}

resource "aws_iam_role_policy_attachment" "break_glass_admin" {
  role       = aws_iam_role.break_glass_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
