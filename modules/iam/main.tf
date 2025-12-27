# Creazione gruppi e utenti, aggiunta membri ai gruppi

resource "aws_iam_group" "juniors" {
  name = "JuniorDevelopers"
}

resource "aws_iam_group" "seniors" {
  name = "SeniorDevOps"
}

resource "aws_iam_user" "alessandro" {
  name          = "alessandro-junior"
  force_destroy = true
  tags          = { Role = "Junior" }
}

resource "aws_iam_user" "beatrice" {
  name          = "beatrice_senior"
  force_destroy = true
  tags          = { Role = "Senior" }
}

resource "aws_iam_user_group_membership" "alessandro_membership" {
  user   = aws_iam_user.alessandro.name
  groups = [aws_iam_group.juniors.name]
}

resource "aws_iam_user_group_membership" "beatrice_membership" {
  user   = aws_iam_user.beatrice.name
  groups = [aws_iam_group.seniors.name]
}


# Generazione dinamica delle policy JSON

data "aws_iam_policy_document" "junior_access" {
  statement {
    sid    = "AllowListAndRead"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetObject"
    ]
    resources = [
      var.bucket_arn,
      "${var.bucket_arn}/*"
    ]
  }
}

data "aws_iam_policy_document" "senior_access" {
  statement {
    sid    = "AllowFullS3Access"
    effect = "Allow"
    actions = [
      "s3:*"
    ]
    resources = [
      var.bucket_arn,
      "${var.bucket_arn}/*"
    ]
  }
}

# Creazione managed policies in base ai JSON  

resource "aws_iam_policy" "junior_policy" {
  name        = "JuniorReadOnlyAccess"
  description = "Managed Policy generata da Terraform Data Source"

  policy      = data.aws_iam_policy_document.junior_access.json
}

resource "aws_iam_policy" "senior_policy" {
  name        = "SeniorWriteAccess"
  description = "Managed Policy generata da Terraform Data Source"
  policy      = data.aws_iam_policy_document.senior_access.json
}

# Assegnazione policy ai gruppi

resource "aws_iam_group_policy_attachment" "attach_junior" {
  group      = aws_iam_group.juniors.name
  policy_arn = aws_iam_policy.junior_policy.arn
}

resource "aws_iam_group_policy_attachment" "attach_senior" {
  group      = aws_iam_group.seniors.name
  policy_arn = aws_iam_policy.senior_policy.arn
}