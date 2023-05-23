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
  prefix                    = var.github_repo
  source_output             = "${local.prefix}-source-output"
  build_output              = "${local.prefix}-build-output"
  build_project             = "${local.prefix}-build"
  expiration_window_in_days = 30
  timeout_in_minutes        = 15
}
