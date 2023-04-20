variable "domain" {
  type        = string
  description = "Domain to target these changes on"
}

variable "zone_id" {
  type        = string
  description = "Zone ID to target these changes on"
}

variable "rua_email" {
  type        = string
  description = "Email address to send DMARC aggregate reports to"
}

variable "ruf_email" {
  type        = string
  description = "Email address to send DMARC failure reports to"
}

locals {
  ttl = {
    "forty_eight_hours" = 172800
  }

  # Approach based on recommendations from M3AAWG: https://www.m3aawg.org/sites/default/files/m3aawg_parked_domains_bcp-2022-06.pdf
  records = {
    "spf_on_apex"       = { on = var.domain, type = "TXT", records = ["v=spf1 -all"] },
    "spf_on_subdomains" = { on = "*.${var.domain}", type = "TXT", records = ["v=spf1 -all"] },
    "mx_on_apex"        = { on = var.domain, type = "MX", records = ["0 ."] },
    "mx_on_subdomains"  = { on = "*.${var.domain}", type = "MX", records = ["0 ."] },
    "dmarc"             = { on = "_dmarc.${var.domain}", type = "TXT", records = ["v=DMARC1; p=reject; rua=maillto:${var.rua_email}; ruf=maillto:${var.ruf_email}"] }
    # No SOA record, because this is maintained by AWS, including reporting
  }
}
