variable "region" {
  description = "Primary AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Short project identifier"
  type        = string
  default     = "landing_zone"
}

variable "break_glass_trusted_principal_arn" {
  description = "ARN of the IAM user allowed to assume the break-glass admin role"
  type        = string
}

variable "sso_instance_arn" {
  description = "IAM Identity Center instance ARN"
  type        = string
}

variable "sso_identity_store_id" {
  description = "IAM Identity Center identity store ID"
  type        = string
}
