# trivy:ignore:AVD-AWS-0017 - Log Group Is Not Encrypted
resource "aws_cloudwatch_log_group" "build" {
  name              = "/aws/codebuild/${local.build_project}"
  retention_in_days = 30
}

# trivy:ignore:AVD-AWS-0017 - Log Group Is Not Encrypted
resource "aws_cloudwatch_log_group" "stage" {
  name              = "/aws/codebuild/${local.stage_project}"
  retention_in_days = 30
}

# trivy:ignore:AVD-AWS-0017 - Log Group Is Not Encrypted
resource "aws_cloudwatch_log_group" "production" {
  name              = "/aws/codebuild/${local.production_project}"
  retention_in_days = 30
}
