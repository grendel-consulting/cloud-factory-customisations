resource "aws_route53_zone" "registered" {
  for_each = local.tlds

  name = each.key

  tags = {
    environment = "production"
  }
}

module "workspace" {
  for_each = { for k, v in local.tlds : k => v if v.email == "workspace" }

  source = "./modules/workspace"

  domain             = each.key
  zone_id            = aws_route53_zone.registered[each.key].zone_id
  rua_email          = "dmarc@hrothgar.uriports.com"
  ruf_email          = "dmarc@hrothgar.uriports.com"
  tls_email          = "tlsrpt@hrothgar.uriports.com"
  domain_key         = try(each.value.domain_key, null)
  verification_token = try(each.value.verification_token, null)
}

module "parked" {
  for_each = { for k, v in local.tlds : k => v if v.email == "parked" }

  source = "./modules/parked"

  domain    = each.key
  zone_id   = aws_route53_zone.registered[each.key].zone_id
  rua_email = "dmarc@hrothgar.uriports.com"
}
