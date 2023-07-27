resource "aws_s3_bucket" "S3Bucket" {
  bucket        = var.AssetsBucket
  force_destroy = true

  lifecycle {
    ignore_changes = [
      website,
    ]
  }
}

resource "aws_s3_bucket" "S3Bucket2" {
  force_destroy = true
  bucket        = var.pipelinebucket
}

resource "aws_s3_bucket_policy" "S3BucketPolicy" {
  bucket = aws_s3_bucket.S3Bucket.id
  #policy = "{\"Version\":\"2008-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"AWS\":\"aws_cloudfront_origin_access_identity.example.iam_arn\"},\"Action\":\"s3:GetObject\",\"Resource\":\"arn:aws:s3:::${var.AssetsBucket}/*\"}]}"

  policy = <<EOF
    {
    "Version": "2008-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.CloudFrontCloudFrontOriginAccessIdentity.id}"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${var.AssetsBucket}/*"
        }
    ]
}
EOF
}



resource "aws_s3_bucket_public_access_block" "asset_bucket_all_access" {
  bucket = aws_s3_bucket.S3Bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "asset_bucket_Website_host" {
  bucket = aws_s3_bucket.S3Bucket.id

  index_document {
    suffix = "index.html"
  }
}

