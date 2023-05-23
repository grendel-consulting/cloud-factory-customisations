resource "aws_codestarconnections_connection" "pipeline" {
  name          = "${local.prefix}-connection"
  provider_type = "GitHub"
}
