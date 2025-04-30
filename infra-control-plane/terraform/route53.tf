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
  caa_email          = "security@grendel-consulting.com"
  domain_key         = try(each.value.domain_key, null)
  verification_token = try(each.value.verification_token, null)
}

module "parked" {
  for_each = { for k, v in local.tlds : k => v if v.email == "parked" }

  source  = "grendel-consulting/securely_parked_domain/aws"
  version = "0.1.1"

  domain    = each.key
  zone_id   = aws_route53_zone.registered[each.key].zone_id
  rua_email = "dmarc@hrothgar.uriports.com"
  caa_email = "security@grendel-consulting.com"
}

resource "aws_route53_record" "github" {
  for_each = { for k, v in local.challenge_tokens : k => v }

  zone_id = aws_route53_zone.registered[each.value.domain].zone_id
  name    = "_github-challenge-${each.value.challenge}"
  type    = "TXT"
  ttl     = local.ttl.five_minutes

  records = [each.value.response]
}

resource "aws_route53_record" "status" {
  for_each = { for k, v in local.tlds : k => v if try(v.status, null) != null }

  zone_id = aws_route53_zone.registered[each.key].zone_id
  name    = "status.${each.key}"
  type    = "CNAME"
  ttl     = local.ttl.five_minutes

  records = [each.value.status]
}
