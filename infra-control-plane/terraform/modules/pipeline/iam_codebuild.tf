resource "aws_iam_role" "build" {
  name               = "${local.prefix}-build-role"
  assume_role_policy = data.aws_iam_policy_document.build_assume_role.json
}

# trivy:ignore:AVD-AWS-0057 - IAM Policy Document Uses Wildcarded Action
data "aws_iam_policy_document" "build_policy" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    resources = [
      "arn:aws:iam::${aws_ssm_parameter.staging.value}:role/tfc-role",
      "arn:aws:iam::${aws_ssm_parameter.production.value}:role/tfc-role"
    ]
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

    resources = [
      var.tfc_token,
      aws_ssm_parameter.staging.arn,
      aws_ssm_parameter.production.arn,
    ]
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
