variable "region" {
  description = "Primary AWS region for the landing zone"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Short project identifier used in resource names"
  type        = string
  default     = "landing_zone"
}
