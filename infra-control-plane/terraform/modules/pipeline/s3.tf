# trivy:ignore:AVD-AWS-0086 - No Public Access Block So Not Blocking Public Access ACLs
# trivy:ignore:AVD-AWS-0087 - No Public Access Block So Not Blocking Public Policies
# trivy:ignore:AVD-AWS-0089 - Bucket Has Logging Disabled
# trivy:ignore:AVD-AWS-0091 - No Public Access Block So Not Ignoring Public ACLs
# trivy:ignore:AVD-AWS-0093 - No Public Access Block So Not Restricing Public Buckets
# trivy:ignore:AVD-AWS-0094 - Bucket Does Not Have A Corresponding Public Access Block
resource "aws_s3_bucket" "artefacts" {
  bucket = "${local.prefix}-pipeline-artefacts"

  # Since 2023-04-06, all new buckets are private by default
  # We can omit public access block and acl configuration

  tags = {
    Environment = "Prod"
  }
}

data "aws_iam_policy_document" "artefacts_assets" {
  statement {
    sid    = "AllowSSLRequestsOnly"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:*",
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }

    resources = [
      aws_s3_bucket.artefacts.arn,
      "${aws_s3_bucket.artefacts.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "artefacts_assets" {
  bucket = aws_s3_bucket.artefacts.id
  policy = data.aws_iam_policy_document.artefacts_assets.json
}


resource "aws_s3_bucket_server_side_encryption_configuration" "artefacts" {
  bucket = aws_s3_bucket.artefacts.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.artefacts.id
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "artefacts" {
  bucket = aws_s3_bucket.artefacts.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "artefacts" {
  depends_on = [aws_s3_bucket_versioning.artefacts]
  bucket     = aws_s3_bucket.artefacts.id

  rule {
    id     = "CleanUpOldVersions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = local.expiration_window_in_days
    }
  }
}
