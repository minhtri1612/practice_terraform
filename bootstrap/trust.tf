data "aws_iam_policy_document" "github_actions_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    # Repo tạo sau 15/7/2026: sub dùng owner_id + repo_id, KHÔNG phải tên repo
    # vd: repo:minhtri1612@156641195/practice_terraform@1307902298:ref:refs/heads/main
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:${var.github_org_or_user}@${var.github_owner_id}/${var.github_repo}@${var.github_repo_id}:*",
        "repo:${var.github_org_or_user}/${var.github_repo}:*",
      ]
    }
  }
}
