resource "aws_ssm_parameter" "staging" {
  name  = "/work/${var.workload}/staging"
  type  = "String"
  value = "AWS Account ID"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "production" {
  name  = "/work/${var.workload}/production"
  type  = "String"
  value = "AWS Account ID"

  lifecycle {
    ignore_changes = [value]
  }
}
