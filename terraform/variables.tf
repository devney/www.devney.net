variable "aws_region" {
  description = "Region for the S3 bucket. CloudFront is global; the ACM cert is always us-east-1."
  type        = string
  default     = "us-west-2"
}

variable "hostname" {
  description = "Primary site hostname."
  type        = string
  default     = "www.devney.net"
}

variable "alternate_hostnames" {
  description = "Extra hostnames on the ACM cert and CloudFront distribution (after DNS validation)."
  type        = list(string)
  default     = ["devney.net"]
}

variable "price_class" {
  description = "CloudFront price class."
  type        = string
  default     = "PriceClass_100"
}

variable "attach_custom_domain" {
  description = "Set true after the ACM validation CNAMEs exist in ZoneEdit. Until then CloudFront is only reachable at the *.cloudfront.net domain."
  type        = bool
  default     = false
}

variable "basic_auth_username" {
  description = "HTTP basic-auth username enforced by the CloudFront viewer-request function."
  type        = string
  sensitive   = true
}

variable "basic_auth_password" {
  description = "HTTP basic-auth password enforced by the CloudFront viewer-request function."
  type        = string
  sensitive   = true
}
