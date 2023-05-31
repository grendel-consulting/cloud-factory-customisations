resource "aws_ssm_parameter" "staging" {
  name  = "/work/${var.workload}/staging"
  type  = "String"
  value = "1" # Fake AWS Account ID, manually set in SSM

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "production" {
  name  = "/work/${var.workload}/production"
  type  = "String"
  value = "1" # Fake AWS Account ID, manually set in SSM

  lifecycle {
    ignore_changes = [value]
  }
}
