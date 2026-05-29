variable "instance_arn" {
  description = "ARN of the IAM Identity Center instance"
  type        = string
}

variable "identity_store_id" {
  description = "ID of the Identity Store"
  type        = string
}

variable "target_account_id" {
  description = "AWS account ID to assign permission sets to"
  type        = string
}
