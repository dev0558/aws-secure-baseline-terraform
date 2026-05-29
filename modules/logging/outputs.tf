output "cloudtrail_bucket_name" {
  value = aws_s3_bucket.cloudtrail.id
}

output "cloudtrail_kms_key_arn" {
  value = aws_kms_key.cloudtrail.arn
}

output "cloudtrail_log_group_name" {
  value = aws_cloudwatch_log_group.cloudtrail.name
}

output "cloudtrail_arn" {
  value = aws_cloudtrail.main.arn
}
