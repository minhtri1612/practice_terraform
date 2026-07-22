variable "aws_region" {
  description = "AWS region cho state backend"
  type        = string
  default     = "ap-southeast-2"
}

variable "state_bucket_name" {
  description = "Tên S3 bucket chứa tfstate (phải unique global)"
  type        = string
}

variable "lock_table_name" {
  description = "Tên DynamoDB table dùng state lock"
  type        = string
  default     = "terraform-state-lock"
}

variable "github_org_or_user" {
  description = "GitHub org hoặc username (để tạo OIDC trust cho Actions)"
  type        = string
}

variable "github_repo" {
  description = "Tên repo GitHub (không gồm org)"
  type        = string
  default     = "practice_terraform"
}

variable "github_owner_id" {
  description = "GitHub owner ID (numeric). Repo tạo sau 15/7/2026 dùng immutable sub claim."
  type        = string
}

variable "github_repo_id" {
  description = "GitHub repository ID (numeric). Repo tạo sau 15/7/2026 dùng immutable sub claim."
  type        = string
}
