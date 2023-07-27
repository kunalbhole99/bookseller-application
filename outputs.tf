output "neptune_endpoint" {
  value = aws_neptune_cluster.NeptuneDBCluster.endpoint
}

output "doamin_name" {
  value = aws_cloudfront_distribution.CloudFrontDistribution.domain_name
}
