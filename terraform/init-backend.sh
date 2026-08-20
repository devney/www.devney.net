#!/usr/bin/env bash
# Configure the S3 backend using the account ID of the current AWS credentials.
set -euo pipefail

cd "$(dirname "$0")"

account_id="$(aws sts get-caller-identity --query Account --output text)"
bucket="${account_id}-terraform-state"

echo "Using backend s3://${bucket}/www.devney.net/terraform.tfstate"

terraform init \
  -backend-config="bucket=${bucket}" \
  "$@"
