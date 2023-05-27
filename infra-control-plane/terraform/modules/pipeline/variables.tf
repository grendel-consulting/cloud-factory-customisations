variable "name" {
  type        = string
  description = "Name of the pipeline"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.name))
    error_message = "Name must match a-z0-9-"
  }

  validation {
    condition     = (length(var.name) < 33)
    error_message = "Limit to 32 characters because of CodeStar and S3 constraints."
  }
}
variable "github_owner" {
  type        = string
  description = "GitHub Organisation or Username owning the repositories"
}

variable "github_repo" {
  type        = string
  description = "GitHub Repository to use as the source"
}

variable "github_target_branch" {
  type        = string
  description = "Branch to use as the source"
  default     = "main"
}

variable "connection" {
  type        = string
  description = "ARN of the CodeStar Connection"
}

locals {
  prefix                    = "g6c-${var.name}"
  build_image               = "aws/codebuild/standard:7.0"
  source_output             = "source-output"
  build_output              = "build-output"
  build_project             = "${local.prefix}-build"
  stage_output              = "stage-output"
  stage_project             = "${local.prefix}-stage"
  expiration_window_in_days = 30
  timeout_in_minutes        = 15
}
