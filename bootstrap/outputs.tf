output "state_bucket_name" {
  description = "S3 bucket holding Terraform state"
  value       = aws_s3_bucket.tfstate.id
}

output "lock_table_name" {
  description = "DynamoDB table for state locking"
  value       = aws_dynamodb_table.tfstate_lock.name
}

output "kms_key_arn" {
  description = "KMS key ARN used for state encryption"
  value       = aws_kms_key.tfstate.arn
}

output "region" {
  description = "AWS region"
  value       = var.region
}
