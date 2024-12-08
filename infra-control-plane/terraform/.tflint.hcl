plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

rule "terraform_required_version" {
  enabled = false   # Declared in Jinja template
}

rule "terraform_required_providers" {
  enabled = false   # Declared in Jinja template
}

rule "terraform_module_pinned_source" {
  enabled = false
}

plugin "aws" {
    enabled = true
    version = "0.36.0"
    source  = "github.com/terraform-linters/tflint-ruleset-aws"
}
