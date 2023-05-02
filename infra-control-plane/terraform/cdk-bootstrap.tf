module "cdk_bootstrap" {
  source = "github.com/grendel-consulting/terraform-aws-cdk_bootstrap?ref=v17"

  file_assets_bucket_kms_key_id = "AWS_MANAGED"
  qualifier                     = "v17-jerboa" # Unique and searchable, but meaningless
  region                        = data.aws_region.current.name
}
