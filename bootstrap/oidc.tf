# IAM OIDC cho GitHub Actions — không cần lưu AWS Access Key dài hạn trong GitHub Secrets.

data "aws_caller_identity" "current" {}

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]

  # Thumbprint GitHub Actions OIDC (AWS vẫn yêu cầu field này)
  thumbprint_list = ["ffffffffffffffffffffffffffffffffffffffff"]
}

locals {
  # Cho phép workflow trên branch main + mọi PR của repo này
  github_sub_main = "repo:${var.github_org_or_user}/${var.github_repo}:ref:refs/heads/main"
  github_sub_pr   = "repo:${var.github_org_or_user}/${var.github_repo}:pull_request"
}

resource "aws_iam_role" "github_actions" {
  name = "github-actions-terraform"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = [
              local.github_sub_main,
              local.github_sub_pr,
            ]
          }
        }
      }
    ]
  })

  tags = {
    Purpose   = "github-actions-terraform"
    ManagedBy = "terraform-bootstrap"
  }
}

# Practice: quyền rộng. Production nên thu hẹp theo least privilege.
resource "aws_iam_role_policy" "github_actions_terraform" {
  name = "terraform-manage"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "TerraformState"
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
        ]
        Resource = [
          aws_s3_bucket.tfstate.arn,
          "${aws_s3_bucket.tfstate.arn}/*",
        ]
      },
      {
        Sid    = "TerraformLock"
        Effect = "Allow"
        Action = [
          "dynamodb:DescribeTable",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
        ]
        Resource = aws_dynamodb_table.tf_lock.arn
      },
      {
        Sid      = "PracticeInfraBroad"
        Effect   = "Allow"
        Action   = ["*"]
        Resource = ["*"]
        # Restrict bằng Condition nếu muốn; practice giữ rộng để dễ học
      }
    ]
  })
}
