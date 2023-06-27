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

variable "tls_email" {
  type        = string
  description = "Email address to send TLS reports to"
}

variable "caa_email" {
  type        = string
  description = "Email address to send CAA violation reports to"
  default     = null
}

variable "consolidated_mx" {
  type        = bool
  description = "Whether to use consolidated MX records, i.e. if signed up for Google Workspace after 2023, or not"
  # https://support.google.com/a/answer/174125?hl=en&ref_topic=2683820&fl=1&sjid=12557949926267715111-NA
  default = false
}

variable "domain_key" {
  type        = list(string)
  description = "Domain key to use for DKIM"
  default     = null
}

variable "verification_token" {
  type        = string
  description = "Token to verify ownership of the domain"
  default     = null
}

locals {
  ttl = {
    "forty_eight_hours" = 172800,
    "twenty_four_hours" = 86400,
    "one_hour"          = 3600,
    "five_minutes"      = 300
  }

  pre_2023_mx_records = [
    "1 ASPMX.L.GOOGLE.COM",
    "5 ALT1.ASPMX.L.GOOGLE.COM",
    "5 ALT2.ASPMX.L.GOOGLE.COM",
    "10 ALT3.ASPMX.L.GOOGLE.COM",
    "10 ALT4.ASPMX.L.GOOGLE.COM"
  ]
  post_2023_mx_records = [
    "1 SMTP.GOOGLE.COM"
  ]

  caa_issuers = [
    "amazon.com",
    "amazontrust.com",
    "awstrust.com",
    "amazonaws.com"
  ]

  caa_report_recipient = var.caa_email != null ? var.caa_email : format("hostmaster@%s", var.domain)
}
