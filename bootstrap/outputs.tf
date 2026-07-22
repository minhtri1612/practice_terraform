output "state_bucket_name" {
  description = "Đưa vào backend.tf của infra/"
  value       = aws_s3_bucket.tfstate.id
}

output "lock_table_name" {
  description = "Đưa vào backend.tf của infra/"
  value       = aws_dynamodb_table.tf_lock.name
}

output "aws_region" {
  value = var.aws_region
}

output "github_actions_role_arn" {
  description = "Set GitHub Actions secret/var: AWS_ROLE_ARN"
  value       = aws_iam_role.github_actions.arn
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
