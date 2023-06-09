resource "aws_codepipeline" "codepipeline" {
  name     = "${local.prefix}-pipeline"
  role_arn = aws_iam_role.pipeline.arn

  artifact_store {
    location = aws_s3_bucket.artefacts.bucket
    type     = "S3"

    encryption_key {
      id   = aws_kms_key.artefacts.id
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = [local.source_output]

      configuration = {
        ConnectionArn        = var.connection
        FullRepositoryId     = "${var.github_owner}/${var.github_repo}"
        BranchName           = var.github_target_branch
        OutputArtifactFormat = "CODEBUILD_CLONE_REF"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build_And_Synth"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = [local.source_output]
      output_artifacts = [local.build_output]
      version          = "1"

      configuration = {
        ProjectName = local.build_project
      }
    }
  }

  stage {
    name = "Staging"

    action {
      name             = "Deploy_Staging"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = [local.build_output]
      output_artifacts = [local.stage_output]
      version          = "1"

      configuration = {
        ProjectName = local.stage_project
      }
    }
  }

  stage {
    name = "Delivery"

    action {
      name             = "Deploy_Production"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = [local.build_output]
      output_artifacts = [local.production_output]
      version          = "1"

      configuration = {
        ProjectName = local.production_project
      }
    }
  }
}
