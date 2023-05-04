data "aws_ssm_parameter" "control_plane" {
  name = "/aft/account-request/custom-fields/control-plane"
}
