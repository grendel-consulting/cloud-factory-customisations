locals {
  github_owner          = "grendel-consulting"
  tfc_hostname          = "app.terraform.io"
  tfc_organisation_name = "grendel-consulting"
  tfc_project_name      = "Default Project"
  tfc_aws_audience      = "aws.workload.identity"

  # Repositories, in an S3 friendly format, for their pipelines
  repositories = {
    "grendel-consulting-com" = {
      github_repo = "www.grendel-consulting.com"
      workload    = "corporate-site"
    }
  }

  # Domain names, in a DNS friendly format
  tlds = {
    "comorian.io" : { "email" : "parked" },
    "grendel-consulting.com" : {
      "email" : "workspace",
      "domain_key" : ["MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCGISnYSs6/CPxxQcoMZE6XTim5q9eLlbvBLSvHe49ep/WMWnfm1gmHfhzCmdVVNZNeZ7p5pnZrehQsDpmkvT4020K6E0gcPp7gDBPWpbSfwteXfiL5VqPwhuukB/3eMpUMbJwb9t0eRC+D6GMaNOuhQ+HefgLnmWHUWFGdgDSmZQIDAQAB"], # pragma: allowlist secret
      "github" : { "owner" : local.github_owner, "token" : "4988aa2e40" }                                                                                                                                                                          # pragma: allowlist secret
    },
    "grendel-realms.com" : { "email" : "parked" },
    "grendel.consulting" : {
      "email" : "workspace",
      "verification_token" : "A8-C3FqhsmJJenvUj3HrauVI4yFpVS9Xeh8oy7GrutU" # pragma: allowlist secret
    },
    "khaen.com" : { "email" : "workspace" },
    "khaen.net" : { "email" : "parked" },
    "onibi.co.uk" : {
      "email" : "workspace",
      "domain_key" : ["MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAihpko/MAIOSrqPm3S0iDIz09EoLIzf/6W+4M+rM/TnxwM35QQyOJngUHpSeWwTQ6GRET7QPmoDkzYF5F0lOUGNss2VUoTxVY+mJV1bXDZxOY6dogrLDmeXqNMBgQq3V3at5EPqUKB7MsdVQkRPV+jXxnNxCaNQ/Do34DdQ8gDKiG", "3QS4RGWfDack+3cl1/2iQmKzDEeMY1xDBlXPbOyVPiGXom2f2s7LdC+dvrdgLYUUy6E6Q7c3DeOrvNnTZ4aXdRYoK9nKbwHxsQrbdC8QpxiXt80eZR9EpwChmbo9FzxeAXg9k5q3LjCdEErN6WwUJpZ3IZmWwVoq3j7NTAgLVwIDAQAB"], # pragma: allowlist secret
      "verification_token" : "oaWXQ40qVrrOSkcW7BV1vhtkpkBV_a_zbx2EqI1-pKs"                                                                                                                                                                                                                                                                                                                                                             # pragma: allowlist secret
    },
    "risen.world" : { "email" : "parked" }
  }

  ttl = {
    "forty_eight_hours" = 172800,
    "twenty_four_hours" = 86400,
    "one_hour"          = 3600,
    "five_minutes"      = 300
  }
}
