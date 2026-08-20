data "aws_caller_identity" "current" {}

locals {
  bucket_name = "${data.aws_caller_identity.current.account_id}-${replace(var.hostname, ".", "-")}"
  aliases     = concat([var.hostname], var.alternate_hostnames)
  origin_id   = "s3-site"

  common_tags = {
    Project   = var.hostname
    ManagedBy = "terraform"
  }
}
