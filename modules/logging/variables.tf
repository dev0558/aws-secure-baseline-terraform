variable "project_name" {
  description = "Short project identifier used in resource names"
  type        = string
  default     = "landing_zone"
}

variable "log_retention_days" {
  description = "CloudWatch Logs retention period"
  type        = number
  default     = 90
}

variable "log_glacier_transition_days" {
  description = "Days after which S3 logs transition to Glacier"
  type        = number
  default     = 90
}
