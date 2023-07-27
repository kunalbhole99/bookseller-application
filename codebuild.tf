resource "aws_codebuild_project" "CodeBuildProject" {
  depends_on = [aws_s3_bucket.S3Bucket2]

  description = "Creating AWS CodeBuild project"
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    type         = "LINUX_CONTAINER"
    image        = "aws/codebuild/standard:2.0"
    environment_variable {
      name  = "S3_BUCKET"
      value = aws_s3_bucket.S3Bucket2.id
    }
  }
  name         = "mybookstore-build"
  service_role = aws_iam_role.mybookstore-codebuild-role.arn

  source {
    type      = "CODEPIPELINE"
    buildspec = <<EOF
version: 0.2
phases:
  install:
    runtime-versions:
      nodejs: 10
  pre_build:
    commands:
      - echo Installing NPM dependencies...
      - npm install
  build:
    commands:
      - npm run build
  post_build:
    commands:
      - echo Uploading to AssetsBucket
      - aws s3 cp --recursive ./build s3://${var.AssetsBucket}/
      - aws s3 cp --cache-control="max-age=0, no-cache, no-store, must-revalidate" ./build/service-worker.js s3://${var.AssetsBucket}/
      - aws s3 cp --cache-control="max-age=0, no-cache, no-store, must-revalidate" ./build/index.html s3://${var.AssetsBucket}/
      - aws cloudfront create-invalidation --distribution-id ${aws_cloudfront_distribution.CloudFrontDistribution.id} --paths /index.html /service-worker.js
artifacts:
  files:
    - '**/*'
  base-directory: build
EOF
  }

  tags = {
    "app-name" = var.ProjectName
  }

  build_timeout = 5
}

# data "aws_cloudformation_stack" "CodeBuildProjectMetadata" {
#   name = aws_codebuild_project.CodeBuildProject.name
# }
