terraform {
  required_version = ">= 1.5.0"

  # Bucket is "{account_id}-terraform-state". Backends cannot interpolate
  # data sources, so the account ID comes from the active AWS credentials
  # at init: ./init-backend.sh
  backend "s3" {
    key          = "www.devney.net/terraform.tfstate"
    region       = "us-west-2"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}
