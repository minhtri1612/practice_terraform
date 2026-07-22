# Temporary: chỉ check aud — để xác định có phải do claim `sub` không khớp.
# Sau khi CI xanh, siết lại sub = repo:OWNER/REPO:*

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

    # Siết theo repo (bật lại sau khi debug xong). Tạm comment để unblock CI.
    # condition {
    #   test     = "StringLike"
    #   variable = "token.actions.githubusercontent.com:sub"
    #   values   = ["repo:${var.github_org_or_user}/${var.github_repo}:*"]
    # }
  }
}
