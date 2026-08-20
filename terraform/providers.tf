provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

# ACM certificates for CloudFront must be in us-east-1.
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"

  default_tags {
    tags = local.common_tags
  }
}
