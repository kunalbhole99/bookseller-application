data "aws_availability_zones" "available" {
  state = "available"
}


data "aws_elasticsearch_domain" "my_domain" {
  depends_on  = [aws_elasticsearch_domain.OpenSearchServiceDomain]
  domain_name = var.mybookstore-domain
}






variable "origin_access_identity" {
  type    = string
  default = "output.origin_access"
}

output "origin_access" {
  value = aws_cloudfront_origin_access_identity.CloudFrontCloudFrontOriginAccessIdentity.etag
}



