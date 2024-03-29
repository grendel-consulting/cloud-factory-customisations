data "aws_route53_zone" "existing" {
  zone_id = var.zone_id
}

resource "aws_route53_record" "txt_on_apex" {
  zone_id = data.aws_route53_zone.existing.zone_id
  name    = var.domain
  records = compact(["v=spf1 include:_spf.google.com ~all", var.verification_token == null ? "" : "google-site-verification=${var.verification_token}"])
  type    = "TXT"
  ttl     = local.ttl.one_hour
}

resource "aws_route53_record" "mx_on_apex" {
  zone_id = data.aws_route53_zone.existing.zone_id
  name    = var.domain
  records = var.consolidated_mx ? local.post_2023_mx_records : local.pre_2023_mx_records
  type    = "MX"
  ttl     = local.ttl.five_minutes
}

resource "aws_route53_record" "dkim" {
  for_each = var.domain_key == null ? {} : { "google" = var.domain_key }
  zone_id  = data.aws_route53_zone.existing.zone_id
  name     = "${each.key}._domainkey.${var.domain}"
  records  = concat(["v=DKIM1; k=rsa; p="], each.value)
  type     = "TXT"
  ttl      = local.ttl.forty_eight_hours
}

resource "aws_route53_record" "dmarc" {
  zone_id = data.aws_route53_zone.existing.zone_id
  name    = "_dmarc.${var.domain}"
  records = ["v=DMARC1; p=quarantine; rua=mailto:${var.rua_email}; ruf=mailto:${var.ruf_email}; fo=1:d:s"]
  type    = "TXT"
  ttl     = local.ttl.one_hour
}

resource "aws_route53_record" "tls" {
  zone_id = data.aws_route53_zone.existing.zone_id
  name    = "_smtp.tls.${var.domain}"
  records = ["v=TLSRPTv1; rua=mailto:${var.tls_email}"]
  type    = "TXT"
  ttl     = local.ttl.forty_eight_hours
}

resource "aws_route53_record" "caa" {
  zone_id = data.aws_route53_zone.existing.zone_id
  name    = var.domain
  records = flatten(
    [
      "0 issue \";\"",
      [for issuer in local.caa_issuers : format("0 issue \"%s\"", issuer)],
      format("0 iodef \"mailto:%s\"", local.caa_report_recipient),
    ]
  )
  type = "CAA"
  ttl  = local.ttl.forty_eight_hours
}
