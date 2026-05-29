output "guardduty_detector_id" {
  value = aws_guardduty_detector.main.id
}

output "config_bucket_name" {
  value = aws_s3_bucket.config.id
}

output "config_recorder_name" {
  value = aws_config_configuration_recorder.main.name
}

output "security_hub_arn" {
  value = aws_securityhub_account.main.arn
}
