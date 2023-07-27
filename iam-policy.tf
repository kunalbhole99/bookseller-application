resource "aws_iam_role_policy" "IAMPolicy" {
  policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":[\"ec2:CreateNetworkInterface\",\"ec2:DescribeNetworkInterfaces\",\"ec2:DeleteNetworkInterface\",\"ec2:DetachNetworkInterface\"],\"Resource\":\"*\",\"Effect\":\"Allow\"}]}"
  role   = aws_iam_role.mybookstore-bookstoreNeptuneIAMAttachLambdaRole.name
}

resource "aws_iam_role_policy" "IAMPolicy2" {
  policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":[\"rds:AddRoleToDBCluster\",\"rds:DescribeDBClusters\"],\"Resource\":[\"*\"],\"Effect\":\"Allow\"},{\"Action\":[\"iam:PassRole\"],\"Resource\":[\"arn:aws:iam::${var.account_id}:role/mybookstore-bookstoreNeptuneLoaderS3ReadRole-MWI6J8RTUSCM\"],\"Effect\":\"Allow\"}]}"
  role   = aws_iam_role.mybookstore-bookstoreNeptuneIAMAttachLambdaRole.name
}

resource "aws_iam_role_policy" "IAMPolicy3" {
  policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":[\"s3:List*\",\"s3:DeleteObject\"],\"Resource\":[\"arn:aws:s3:::${var.AssetsBucket}\",\"arn:aws:s3:::${var.pipelinebucket}\",\"arn:aws:s3:::${var.AssetsBucket}/*\",\"arn:aws:s3:::${var.pipelinebucket}/*\"],\"Effect\":\"Allow\"}]}"
  role   = aws_iam_role.mybookstore-BucketCleanupRole.name
}

resource "aws_iam_role_policy" "IAMPolicy4" {
  policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":[\"s3:Get*\",\"s3:List*\"],\"Resource\":\"*\",\"Effect\":\"Allow\"}]}"
  role   = aws_iam_role.mybookstore-bookstoreNeptuneLoaderS3ReadRole.name
}

resource "aws_iam_role_policy" "IAMPolicy5" {
  policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":[\"logs:CreateLogStream\",\"logs:PutLogEvents\"],\"Resource\":\"arn:aws:logs:us-east-1:${var.account_id}:log-group:/aws/lambda/mybookstore-bookstoreNeptuneIAMAttachLambda-WS7UtWOdDKdh:*\",\"Effect\":\"Allow\"}]}"
  role   = aws_iam_role.mybookstore-bookstoreNeptuneIAMAttachLambdaRole.name
}

resource "aws_iam_role_policy" "IAMPolicy6" {
  policy = "{\"Statement\":[{\"Action\":[\"logs:CreateLogStream\",\"logs:PutLogEvents\",\"logs:CreateLogGroup\",\"cloudfront:CreateInvalidation\"],\"Resource\":\"*\",\"Effect\":\"Allow\"}]}"
  role   = aws_iam_role.mybookstore-codebuild-role.name
}

resource "aws_iam_role_policy" "IAMPolicy7" {
  policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":[\"logs:CreateLogGroup\"],\"Resource\":\"arn:aws:logs:us-east-1:${var.account_id}:*\",\"Effect\":\"Allow\"}]}"
  role   = aws_iam_role.mybookstore-bookstoreNeptuneIAMAttachLambdaRole.name
}

resource "aws_iam_role_policy" "IAMPolicy8" {
  policy = "{\"Statement\":[{\"Action\":[\"s3:PutObject\",\"s3:GetObject\",\"s3:GetObjectVersion\",\"s3:GetBucketVersioning\"],\"Resource\":[\"arn:aws:s3:::${var.AssetsBucket}/*\",\"arn:aws:s3:::${var.pipelinebucket}/*\"],\"Effect\":\"Allow\"}]}"
  role   = aws_iam_role.mybookstore-codebuild-role.name
}

resource "aws_iam_role_policy" "IAMPolicy9" {
  policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":[\"logs:CreateLogGroup\"],\"Resource\":\"arn:aws:logs:us-east-1:${var.account_id}:*\",\"Effect\":\"Allow\"}]}"
  role   = aws_iam_role.mybookstore-bookstoreNeptuneLoaderLambdaRole.name
}

resource "aws_iam_role_policy" "IAMPolicy10" {
  policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":[\"ec2:CreateNetworkInterface\",\"ec2:DescribeNetworkInterfaces\",\"ec2:DeleteNetworkInterface\",\"ec2:DetachNetworkInterface\"],\"Resource\":\"*\",\"Effect\":\"Allow\"}]}"
  role   = aws_iam_role.mybookstore-bookstoreNeptuneLoaderLambdaRole.name
}

resource "aws_iam_role_policy" "IAMPolicy11" {
  policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":[\"logs:CreateLogGroup\"],\"Resource\":\"arn:aws:logs:us-east-1:${var.account_id}:*\",\"Effect\":\"Allow\"}]}"
  role   = aws_iam_role.mybookstore-BookstoreCogn-cognitoDefaultUserLambda.name
}

resource "aws_iam_role_policy" "IAMPolicy12" {
  policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":[\"cognito-idp:AdminCreateUser\",\"cognito-idp:AdminSetUserPassword\"],\"Resource\":\"arn:aws:cognito-idp:*:${var.account_id}:userpool/*\",\"Effect\":\"Allow\"}]}"
  role   = aws_iam_role.mybookstore-BookstoreCogn-cognitoDefaultUserLambda.name
}

resource "aws_iam_role_policy" "IAMPolicy13" {
  policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":[\"mobileanalytics:PutEvents\",\"cognito-sync:*\"],\"Resource\":\"*\",\"Effect\":\"Allow\"}]}"
  role   = aws_iam_role.mybookstore-CognitoUnAuthorizedRole.name
}

resource "aws_iam_role_policy" "IAMPolicy14" {
  policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":[\"es:ESHttpPost\",\"es:ESHttpGet\"],\"Resource\":\"arn:aws:es:us-east-1:${var.account_id}:domain/mybookstore-domain/*\",\"Effect\":\"Allow\"},{\"Action\":[\"s3:ListBucket\",\"s3:GetObject\"],\"Resource\":\"arn:aws:s3:::aws-bookstore-demo-app-us-east-1/*\",\"Effect\":\"Allow\"},{\"Action\":[\"dynamodb:DescribeStream\",\"dynamodb:GetRecords\",\"dynamodb:GetShardIterator\",\"dynamodb:ListStreams\"],\"Resource\":[\"arn:aws:dynamodb:us-east-1:${var.account_id}:table/mybookstore-Books\",\"arn:aws:dynamodb:us-east-1:${var.account_id}:table/mybookstore-Books/stream/*\"],\"Effect\":\"Allow\"}]}"
  role   = aws_iam_role.mybookstore-OSSearchRole.name
}

resource "aws_iam_role_policy" "IAMPolicy15" {
  policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":[\"logs:CreateLogStream\",\"logs:PutLogEvents\"],\"Resource\":\"arn:aws:logs:us-east-1:${var.account_id}:log-group:/aws/lambda/mybookstore-BookstoreCogn-cognitoDefaultUserLambda-NbCSgcopTx4m:*\",\"Effect\":\"Allow\"}]}"
  role   = aws_iam_role.mybookstore-BookstoreCogn-cognitoDefaultUserLambda.name
}

resource "aws_iam_role_policy" "IAMPolicy16" {
  policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":[\"logs:CreateLogStream\",\"logs:PutLogEvents\"],\"Resource\":\"arn:aws:logs:us-east-1:${var.account_id}:log-group:/aws/lambda/mybookstore-bookstoreNeptuneLoaderLambda-Zs1u6a4OJWNE:*\",\"Effect\":\"Allow\"}]}"
  role   = aws_iam_role.mybookstore-bookstoreNeptuneLoaderLambdaRole.name
}

resource "aws_iam_role_policy" "IAMPolicy17" {
  policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":[\"dynamodb:PutItem\",\"dynamodb:Query\",\"dynamodb:UpdateTable\",\"dynamodb:UpdateItem\",\"dynamodb:BatchWriteItem\",\"dynamodb:GetItem\",\"dynamodb:Scan\",\"dynamodb:DeleteItem\"],\"Resource\":[\"arn:aws:dynamodb:us-east-1:${var.account_id}:table/mybookstore-Books\",\"arn:aws:dynamodb:us-east-1:${var.account_id}:table/mybookstore-Orders\",\"arn:aws:dynamodb:us-east-1:${var.account_id}:table/mybookstore-Cart\",\"arn:aws:dynamodb:us-east-1:${var.account_id}:table/mybookstore-Books/*\"],\"Effect\":\"Allow\"}]}"
  role   = aws_iam_role.mybookstore-DynamoDbLambda.name
}

resource "aws_iam_role_policy" "IAMPolicy18" {
  policy = "{\"Statement\":[{\"Action\":[\"s3:PutObject\",\"s3:GetObject\"],\"Resource\":\"arn:aws:s3:::${var.pipelinebucket}/*\",\"Effect\":\"Allow\"}]}"
  role   = aws_iam_role.mybookstore-CodePipeline-Role.name
}

resource "aws_iam_role_policy" "IAMPolicy19" {
  policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":\"sns:publish\",\"Resource\":\"*\",\"Effect\":\"Allow\"}]}"
  role   = aws_iam_role.mybookstore-SNSRole.name
}

resource "aws_iam_role_policy" "IAMPolicy20" {
  policy = "{\"Statement\":[{\"Action\":[\"codecommit:GetBranch\",\"codecommit:GetCommit\",\"codecommit:UploadArchive\",\"codecommit:GetUploadArchiveStatus\",\"codecommit:CancelUploadArchive\"],\"Resource\":\"arn:aws:codecommit:us-east-1:${var.account_id}:mybookstore-WebAssets\",\"Effect\":\"Allow\"}]}"
  role   = aws_iam_role.mybookstore-CodePipeline-Role.name
}

resource "aws_iam_role_policy" "IAMPolicy21" {
  policy = "{\"Statement\":[{\"Action\":[\"codebuild:BatchGetBuilds\",\"codebuild:StartBuild\"],\"Resource\":\"arn:aws:codebuild:us-east-1:${var.account_id}:project/mybookstore-build\",\"Effect\":\"Allow\"}]}"
  role   = aws_iam_role.mybookstore-CodePipeline-Role.name
}

resource "aws_iam_role_policy" "IAMPolicy22" {
  policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":[\"mobileanalytics:PutEvents\",\"cognito-sync:*\",\"cognito-identity:*\"],\"Resource\":\"*\",\"Effect\":\"Allow\"},{\"Action\":[\"execute-api:Invoke\"],\"Resource\":\"arn:aws:execute-api:us-east-1:${var.account_id}:${aws_api_gateway_rest_api.AppApi.id}/*\",\"Effect\":\"Allow\"}]}"
  role   = aws_iam_role.mybookstore-CognitoAuthorizedRole.name
}

resource "aws_iam_role_policy" "IAMPolicy23" {
  policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":[\"iam:CreateServiceLinkedRole\"],\"Resource\":\"arn:aws:iam::*:role/aws-service-role/opensearchservice.amazonaws.com/AWSServiceRoleForAmazonOpenSearchService\",\"Effect\":\"Allow\"}]}"
  role   = aws_iam_role.mybookstore-CreateOSRole.name
}

resource "aws_iam_role_policy" "IAMPolicy24" {
  policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":[\"ec2:CreateNetworkInterface\",\"ec2:DescribeNetworkInterfaces\",\"ec2:DeleteNetworkInterface\",\"ec2:DetachNetworkInterface\"],\"Resource\":\"*\",\"Effect\":\"Allow\"}]}"
  role   = aws_iam_role.mybookstore-RecommendationsLambdaRole.name
}

resource "aws_iam_role_policy" "IAMPolicy25" {
  policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":[\"codecommit:GetRepository\",\"codecommit:GitPush\",\"codecommit:GetBranch\",\"codecommit:PutFile\"],\"Resource\":\"arn:aws:codecommit:us-east-1:${var.account_id}:mybookstore-WebAssets\",\"Effect\":\"Allow\"}]}"
  role   = aws_iam_role.mybookstore-SeederRole.name
}

resource "aws_iam_role_policy" "IAMPolicy26" {
  policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":[\"logs:*\"],\"Resource\":\"arn:aws:logs:*:*:*\",\"Effect\":\"Allow\"}]}"
  role   = aws_iam_role.mybookstore-SeederRole.name
}
