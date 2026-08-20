# Replaced on every apply (timestamp) so content/ is published even when
# no other Terraform resources change.
resource "terraform_data" "publish_site" {
  depends_on = [
    aws_s3_bucket_policy.site,
    aws_cloudfront_distribution.site,
  ]

  triggers_replace = [timestamp()]

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOT
      set -euo pipefail
      aws s3 sync "${abspath("${path.module}/../content")}" "s3://${aws_s3_bucket.site.id}" --delete --region "${var.aws_region}"
      aws cloudfront create-invalidation --distribution-id "${aws_cloudfront_distribution.site.id}" --paths "/*"
    EOT
  }
}
