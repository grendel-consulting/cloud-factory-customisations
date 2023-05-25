resource "aws_codebuild_project" "build" {
  name          = local.build_project
  description   = "Build project for ${local.build_project}"
  build_timeout = local.timeout_in_minutes
  service_role  = aws_iam_role.build.arn

  artifacts {
    type = "CODEPIPELINE"
    name = local.build_output
  }

  encryption_key = aws_kms_key.artefacts.arn

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }
  source {
    type            = "CODEPIPELINE"
    git_clone_depth = 0 # Full Clone
  }
}
