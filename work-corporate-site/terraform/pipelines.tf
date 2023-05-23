module "pipelines" {
  for_each = { for k, v in local.repositories : k => v }

  source = "./modules/pipeline"

  github_owner = local.github_owner
  github_repo  = each.value.github_repo
}
