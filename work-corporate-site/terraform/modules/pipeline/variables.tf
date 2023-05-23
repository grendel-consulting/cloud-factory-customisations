variable "name" {
  type        = string
  description = "Name of the pipeline"

  validation {
    condition     = can(regex("^[A-Za-z0-9_-]+$", var.name))
    error_message = "Name must match A-Za-z0-9_-"
  }

  validation {
    condition     = (length(var.name) < 33)
    error_message = "Limit the Name to 32 characters to S3 bucket limits."
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

locals {
  prefix                    = "g6c-${var.name}"
  source_output             = "${local.prefix}-source-output"
  build_output              = "${local.prefix}-build-output"
  build_project             = "${local.prefix}-build"
  expiration_window_in_days = 30
  timeout_in_minutes        = 15
}
