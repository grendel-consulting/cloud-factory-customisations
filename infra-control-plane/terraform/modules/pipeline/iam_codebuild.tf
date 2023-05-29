resource "aws_iam_role" "build" {
  name               = "${local.prefix}-build-role"
  assume_role_policy = data.aws_iam_policy_document.build_assume_role.json
}

# tfsec:ignore:aws-iam-no-policy-wildcards
data "aws_iam_policy_document" "build_policy" {
  dynamic "statement" {
    for_each = length(var.targets) > 0 ? { "k" : "v" } : {}

    content {
      effect = "Allow"

      actions = [
        "sts:AssumeRole",
      ]

      resources = [for s in var.targets : "arn:aws:iam::${s}:role/tfc-role"]
    }
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObjectAcl",
      "s3:PutObject",
    ]

    resources = [
      aws_s3_bucket.artefacts.arn,
      "${aws_s3_bucket.artefacts.arn}/*"
    ]
  }

  statement {
    effect    = "Allow"
    actions   = ["codestar-connections:UseConnection"]
    resources = [var.connection]
  }

  statement {
    effect = "Allow"

    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
    ]

    resources = [var.tfc_token]
  }

  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "build_policy" {
  name   = "${local.prefix}-build-policy"
  role   = aws_iam_role.build.id
  policy = data.aws_iam_policy_document.build_policy.json
}

data "aws_iam_policy_document" "build_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
