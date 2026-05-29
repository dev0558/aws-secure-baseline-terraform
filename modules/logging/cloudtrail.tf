# CloudWatch Logs group
resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = local.log_group_name
  retention_in_days = var.log_retention_days
  kms_key_id        = aws_kms_key.cloudtrail.arn
}

# IAM role for CloudTrail to write to CloudWatch Logs
data "aws_iam_policy_document" "cloudtrail_cw_trust" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "cloudtrail_cw" {
  name               = "${var.project_name}_cloudtrail_cw_logs"
  assume_role_policy = data.aws_iam_policy_document.cloudtrail_cw_trust.json
}

data "aws_iam_policy_document" "cloudtrail_cw" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["${aws_cloudwatch_log_group.cloudtrail.arn}:log-stream:*"]
  }
}

resource "aws_iam_role_policy" "cloudtrail_cw" {
  name   = "${var.project_name}_cloudtrail_cw_logs"
  role   = aws_iam_role.cloudtrail_cw.id
  policy = data.aws_iam_policy_document.cloudtrail_cw.json
}

# The trail itself: multi-region, log file validation, KMS encrypted, with CloudWatch integration
resource "aws_cloudtrail" "main" {
  name                          = "${var.project_name}_trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail.id
  kms_key_id                    = aws_kms_key.cloudtrail.arn
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true

  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_cw.arn

  depends_on = [
    aws_s3_bucket_policy.cloudtrail
  ]
}
