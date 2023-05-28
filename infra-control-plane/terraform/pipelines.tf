resource "aws_codestarconnections_connection" "github" {
  name          = local.github_owner
  provider_type = "GitHub"
}

resource "aws_ssm_parameter" "tfc_token" {
  name  = "/terraform/token"
  type  = "SecureString"
  value = "Terraform Cloud API Token"

  lifecycle {
    ignore_changes = [value]
  }
}

module "pipelines" {
  for_each = { for k, v in local.repositories : k => v }

  source = "./modules/pipeline"

  name         = each.key
  github_owner = local.github_owner
  github_repo  = each.value.github_repo
  connection   = aws_codestarconnections_connection.github.arn
  tfc_token    = aws_ssm_parameter.tfc_token.arn
}
