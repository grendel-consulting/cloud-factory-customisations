resource "aws_route53_zone" "registered" {
  for_each = local.tlds

  name = each.key

  tags = {
    environment = "production"
  }
}
