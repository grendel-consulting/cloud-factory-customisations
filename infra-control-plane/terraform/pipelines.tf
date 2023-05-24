resource "aws_codestarconnections_connection" "github" {
  name          = local.github_owner
  provider_type = "GitHub"
}

module "pipelines" {
  for_each = { for k, v in local.repositories : k => v }

  source = "./modules/pipeline"

  name         = each.key
  github_owner = local.github_owner
  github_repo  = each.value.github_repo
  connection   = aws_codestarconnections_connection.github.arn
}
