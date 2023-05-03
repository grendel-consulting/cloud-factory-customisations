locals {
  control-plane = [for t in data.aws_organizations_organizational_unit_child_accounts.accounts.accounts : t.id if t.name == "infra-control-plane"]
}
