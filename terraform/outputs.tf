output "site_bucket" {
  description = "Private S3 bucket that holds the site files."
  value       = aws_s3_bucket.site.id
}

output "cloudfront_domain_name" {
  description = "CloudFront hostname. Browse here until custom DNS is attached."
  value       = aws_cloudfront_distribution.site.domain_name
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.site.id
}

output "acm_dns_validation_records" {
  description = "CNAME records to create in ZoneEdit so ACM can issue the cert. After they exist, set attach_custom_domain=true and re-apply."
  value = [
    for dvo in aws_acm_certificate.site.domain_validation_options : {
      host    = trimsuffix(dvo.resource_record_name, ".")
      type    = dvo.resource_record_type
      content = trimsuffix(dvo.resource_record_value, ".")
    }
  ]
}

output "www_dns_record" {
  description = "After attach_custom_domain=true, point www at CloudFront. An explicit www CNAME beats the ZoneEdit * wildcard."
  value = {
    host    = "www"
    type    = "CNAME"
    content = aws_cloudfront_distribution.site.domain_name
  }
}

output "publish_command" {
  description = "Same upload CloudFront-invalidate step that terraform apply runs last via terraform_data.publish_site."
  value       = "aws s3 sync ../content s3://${aws_s3_bucket.site.id} --delete && aws cloudfront create-invalidation --distribution-id ${aws_cloudfront_distribution.site.id} --paths '/*'"
}
