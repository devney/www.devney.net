resource "aws_cloudfront_origin_access_control" "site" {
  name                              = var.hostname
  description                       = "Sign requests from CloudFront to the site bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_response_headers_policy" "site" {
  name    = "${local.bucket_name}-security"
  comment = "Baseline browser security headers for ${var.hostname}"

  security_headers_config {
    content_type_options {
      override = true
    }

    frame_options {
      frame_option = "DENY"
      override     = true
    }

    referrer_policy {
      referrer_policy = "strict-origin-when-cross-origin"
      override        = true
    }

    # Do not set includeSubdomains/preload: other names under devney.net
    # (mail, apps, the ZoneEdit wildcard) are not on this distribution.
    strict_transport_security {
      access_control_max_age_sec = 31536000
      include_subdomains         = false
      preload                    = false
      override                   = true
    }

    xss_protection {
      mode_block = true
      protection = true
      override   = true
    }
  }
}

data "aws_cloudfront_cache_policy" "caching_optimized" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_function" "basic_auth" {
  name    = "${replace(var.hostname, ".", "-")}-basic-auth"
  runtime = "cloudfront-js-2.0"
  comment = "HTTP basic auth for ${var.hostname}"
  publish = true
  code = templatefile("${path.module}/basic_auth.js.tftpl", {
    expected_b64 = base64encode("${var.basic_auth_username}:${var.basic_auth_password}")
    realm        = var.hostname
  })
}

resource "aws_cloudfront_distribution" "site" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.hostname
  default_root_object = "index.html"
  http_version        = "http2and3"
  price_class         = var.price_class
  aliases             = var.attach_custom_domain ? local.aliases : []

  origin {
    domain_name              = aws_s3_bucket.site.bucket_regional_domain_name
    origin_id                = local.origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.site.id
  }

  default_cache_behavior {
    target_origin_id       = local.origin_id
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true

    cache_policy_id            = data.aws_cloudfront_cache_policy.caching_optimized.id
    response_headers_policy_id = aws_cloudfront_response_headers_policy.site.id

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.basic_auth.arn
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = var.attach_custom_domain ? false : true
    acm_certificate_arn            = var.attach_custom_domain ? aws_acm_certificate_validation.site[0].certificate_arn : null
    ssl_support_method             = var.attach_custom_domain ? "sni-only" : null
    minimum_protocol_version       = var.attach_custom_domain ? "TLSv1.2_2021" : null
  }
}
