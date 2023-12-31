resource "aws_iam_role" "pipeline" {
  name               = "${local.prefix}-pipeline-role"
  assume_role_policy = data.aws_iam_policy_document.pipeline_assume_role.json
}

# trivy:ignore:AVD-AWS-0057 - IAM Policy Document Uses Wildcarded Action
data "aws_iam_policy_document" "pipeline_policy" {
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
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "pipeline_policy" {
  name   = "${local.prefix}-pipeline-policy"
  role   = aws_iam_role.pipeline.id
  policy = data.aws_iam_policy_document.pipeline_policy.json
}

data "aws_iam_policy_document" "pipeline_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
