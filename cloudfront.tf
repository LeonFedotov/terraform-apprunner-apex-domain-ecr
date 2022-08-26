data "aws_cloudfront_cache_policy" "cache_policy" {
  name = "Managed-CachingDisabled"
}
data "aws_cloudfront_cache_policy" "response_cache_policy" {
  name = "Managed-CORS-With-Preflight"
}
data "aws_cloudfront_cache_policy" "origin_cache_policy" {
  name = "Managed-AllViewer"
}
resource "aws_cloudfront_distribution" "server_distribution" {
  aliases = ["${var.root_domain_name}", "www.${var.root_domain_name}"]
  price_class = "PriceClass_100"
  wait_for_deployment = true
  enabled = true
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = "app-runner-origin"
    cache_policy_id = data.aws_cloudfront_cache_policy.cache_policy.id
    response_headers_policy_id = data.aws_cloudfront_cache_policy.response_cache_policy
    origin_request_policy_id = data.aws_cloudfront_cache_policy.origin_cache_policy
    smooth_streaming = false
  }

  viewer_certificate {
    acm_certificate_arn = "${aws_acm_certificate.certificate.arn}"
    ssl_support_method  = "sni-only"
    cloudfront_default_certificate = false
    minimum_protocol_version = "TLSv1.2_2021"
  }

  origin {
    domain_name = "${aws_apprunner_service.application.service_url}"
    origin_id = "app-runner-origin"
    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "match-viewer"
      origin_ssl_protocols = [ "TLSv1" ]
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
