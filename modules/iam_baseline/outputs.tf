output "break_glass_role_arn" {
  description = "ARN of the break-glass admin role"
  value       = aws_iam_role.break_glass_admin.arn
}
