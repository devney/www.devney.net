resource "aws_acm_certificate" "site" {
  provider = aws.us_east_1

  domain_name               = var.hostname
  subject_alternative_names = var.alternate_hostnames
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "site" {
  count    = var.attach_custom_domain ? 1 : 0
  provider = aws.us_east_1

  certificate_arn = aws_acm_certificate.site.arn
  validation_record_fqdns = distinct([
    for dvo in aws_acm_certificate.site.domain_validation_options : dvo.resource_record_name
  ])
}
