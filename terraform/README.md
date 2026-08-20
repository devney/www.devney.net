# www.devney.net Terraform

Site files live in `../content`. This directory creates the S3 + CloudFront hosting. State is stored at:

`s3://{account_id}-terraform-state/www.devney.net/terraform.tfstate`

The account ID is the one from your **current AWS credentials**, not a value committed in git.

## Initialize the backend

Terraform backends are configured before providers run, so they cannot look up the account ID with `data.aws_caller_identity`. Use `init-backend.sh`, which calls STS and passes `bucket={account_id}-terraform-state` into `terraform init`.

```bash
cd ~/git/www.devney.net/terraform
export AWS_PROFILE=matthew   # or whichever profile owns the account
./init-backend.sh
```

The script prints the S3 URI it will use. Extra args are forwarded to `terraform init`, for example:

```bash
./init-backend.sh -reconfigure
```

Use `-reconfigure` after a backend change or when switching AWS accounts.

After a successful init, `terraform plan` and `terraform apply` work as usual from this directory. You do not need the script again unless the backend config or account changes.
