resource "aws_codebuild_project" "build" {
  name          = local.build_project
  description   = "Build and Synth ${local.build_project}"
  build_timeout = local.timeout_in_minutes
  service_role  = aws_iam_role.build.arn

  artifacts {
    type = "CODEPIPELINE"
    name = local.build_output
  }

  encryption_key = aws_kms_key.artefacts.arn

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = local.build_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }
  source {
    type            = "CODEPIPELINE"
    buildspec       = "pipelines/build.yml"
    git_clone_depth = 0 # Full Clone
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.build.name
    }
  }
}

resource "aws_codebuild_project" "stage" {
  name          = local.stage_project
  description   = "Deploy ${local.stage_project}"
  build_timeout = local.timeout_in_minutes
  service_role  = aws_iam_role.build.arn

  artifacts {
    type = "CODEPIPELINE"
    name = local.stage_output
  }

  encryption_key = aws_kms_key.artefacts.arn

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = local.build_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }
  source {
    type            = "CODEPIPELINE"
    buildspec       = "pipelines/stage.yml"
    git_clone_depth = 0 # Full Clone
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.stage.name
    }
  }
}

resource "aws_codebuild_project" "production" {
  name          = local.production_project
  description   = "Deploy ${local.production_project}"
  build_timeout = local.timeout_in_minutes
  service_role  = aws_iam_role.build.arn

  artifacts {
    type = "CODEPIPELINE"
    name = local.production_output
  }

  encryption_key = aws_kms_key.artefacts.arn

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = local.build_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }
  source {
    type            = "CODEPIPELINE"
    buildspec       = "pipelines/production.yml"
    git_clone_depth = 0 # Full Clone
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.production.name
    }
  }
}
