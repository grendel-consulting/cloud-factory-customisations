resource "aws_route53_zone" "registered" {
  for_each = local.tlds

  name = each.key

  tags = {
    environment = "production"
  }
}

module "parked" {
  for_each = { for k, v in local.tlds : k => v if v.email == "parked" }

  source = "./modules/parked"

  domain    = each.key
  zone_id   = aws_route53_zone.registered[each.key].zone_id
  rua_email = "dmarc@hrothgar.uriports.com"
}
