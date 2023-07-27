
resource "aws_cloudfront_distribution" "CloudFrontDistribution" {

  lifecycle {
    ignore_changes = [
      viewer_certificate,
    ]
  }
  depends_on = [
    aws_s3_bucket_website_configuration.asset_bucket_Website_host
  ]
  origin {
    domain_name = "${aws_s3_bucket.S3Bucket.bucket}.s3.${var.region}.amazonaws.com"
    origin_id   = "S3"

    origin_path = ""
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.CloudFrontCloudFrontOriginAccessIdentity.cloudfront_access_identity_path
    }
  }
  default_cache_behavior {
    allowed_methods = [
      "HEAD",
      "GET"
    ]
    cached_methods = ["GET", "HEAD"]
    compress       = false
    default_ttl    = 86400
    forwarded_values {
      cookies {
        forward = "none"
      }
      query_string = false
    }
    max_ttl                = 31536000
    min_ttl                = 0
    smooth_streaming       = false
    target_origin_id       = "S3"
    viewer_protocol_policy = "https-only"
  }
  comment             = "CDN for mybookstore-assetsbucket-ptrp4fcz0svs"
  default_root_object = "index.html"
  price_class         = "PriceClass_All"
  enabled             = true
  viewer_certificate {
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1"
    ssl_support_method             = "sni-only"
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  http_version    = "http1.1"
  is_ipv6_enabled = true
}

resource "aws_cloudfront_origin_access_identity" "CloudFrontCloudFrontOriginAccessIdentity" {
  comment = "OriginAccessIdentity for mybookstore-assetsbucket-ptrp4fcz0svs"
}
