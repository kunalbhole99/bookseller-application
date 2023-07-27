resource "aws_iam_role" "mybookstore-bookstoreNeptuneLoaderS3ReadRole" {
  path                 = "/"
  name                 = "mybookstore-bookstoreNeptuneLoaderS3ReadRole"
  assume_role_policy   = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"rds.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"
  max_session_duration = 3600
  tags                 = {}
}

resource "aws_iam_role" "mybookstore-bookstoreNeptuneIAMAttachLambdaRole" {
  path                 = "/"
  name                 = "mybookstore-bookstoreNeptuneIAMAttachLambdaRole"
  assume_role_policy   = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"lambda.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"
  max_session_duration = 3600
  tags                 = {}
}

################## mybookstore-BucketCleanupRole ##############

resource "aws_iam_role" "mybookstore-BucketCleanupRole" {
  path                 = "/"
  name                 = "mybookstore-BucketCleanupRole"
  assume_role_policy   = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"lambda.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"
  max_session_duration = 3600
  tags                 = {}
}

resource "aws_iam_role_policy_attachment" "BucketCleanupRole_attachment" {
  role       = aws_iam_role.mybookstore-BucketCleanupRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


##################################################################
resource "aws_iam_role" "mybookstore-codebuild-role" {
  path                 = "/"
  name                 = "mybookstore-codebuild-role"
  assume_role_policy   = "{\"Version\":\"2008-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"codebuild.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"
  max_session_duration = 3600
  tags                 = {}
}

########################## mybookstore-bookstoreNeptuneLoaderLambdaRole ##############

resource "aws_iam_role" "mybookstore-bookstoreNeptuneLoaderLambdaRole" {
  path                 = "/"
  name                 = "mybookstore-bookstoreNeptuneLoaderLambdaRole"
  assume_role_policy   = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"lambda.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"
  max_session_duration = 3600
  tags                 = {}
}


resource "aws_iam_role_policy_attachment" "NeptuneLoaderLambdaRole_attachment1" {
  role       = aws_iam_role.mybookstore-bookstoreNeptuneLoaderLambdaRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}


resource "aws_iam_role_policy_attachment" "NeptuneLoaderLambdaRole_attachment2" {
  role       = aws_iam_role.mybookstore-bookstoreNeptuneLoaderLambdaRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


#######################################################################################

resource "aws_iam_role" "mybookstore-BookstoreCogn-cognitoDefaultUserLambda" {
  path                 = "/"
  name                 = "mybookstore-BookstoreCogn-cognitoDefaultUserLambda"
  assume_role_policy   = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"lambda.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"
  max_session_duration = 3600
  tags                 = {}
}

resource "aws_iam_role" "mybookstore-CognitoAuthorizedRole" {
  path                 = "/"
  name                 = "mybookstore-CognitoAuthorizedRole"
  assume_role_policy   = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Federated\":\"cognito-identity.amazonaws.com\"},\"Action\":\"sts:AssumeRoleWithWebIdentity\",\"Condition\":{\"StringEquals\":{\"cognito-identity.amazonaws.com:aud\":\"${aws_cognito_identity_pool.CognitoIdentityPool.id}\"},\"ForAnyValue:StringLike\":{\"cognito-identity.amazonaws.com:amr\":\"authenticated\"}}}]}"
  max_session_duration = 3600
  tags                 = {}
}

#################### mybookstore-DynamoDbLambda #############

resource "aws_iam_role" "mybookstore-DynamoDbLambda" {
  path                 = "/"
  name                 = "mybookstore-DynamoDbLambda"
  assume_role_policy   = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"lambda.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"
  max_session_duration = 3600
  tags                 = {}
}

resource "aws_iam_role_policy_attachment" "DynamoDbLambda_attachment1" {
  role       = aws_iam_role.mybookstore-DynamoDbLambda.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}


resource "aws_iam_role_policy_attachment" "DynamoDbLambda_attachment2" {
  role       = aws_iam_role.mybookstore-DynamoDbLambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"


}



######################################

resource "aws_iam_role" "mybookstore-CognitoUnAuthorizedRole" {
  path                 = "/"
  name                 = "mybookstore-CognitoUnAuthorizedRole"
  assume_role_policy   = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Federated\":\"cognito-identity.amazonaws.com\"},\"Action\":\"sts:AssumeRoleWithWebIdentity\",\"Condition\":{\"StringEquals\":{\"cognito-identity.amazonaws.com:aud\":\"us-east-1:dd040813-bcdb-45d7-b8e3-87b61f570c29\"},\"ForAnyValue:StringLike\":{\"cognito-identity.amazonaws.com:amr\":\"unauthenticated\"}}}]}"
  max_session_duration = 3600
  tags                 = {}
}

################### mybookstore-OSSearchRole ######################

resource "aws_iam_role" "mybookstore-OSSearchRole" {
  path                 = "/"
  name                 = "mybookstore-OSSearchRole"
  assume_role_policy   = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"lambda.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"
  max_session_duration = 3600
  tags                 = {}
}

resource "aws_iam_role_policy_attachment" "OSSearchRole_attachment1" {
  role       = aws_iam_role.mybookstore-OSSearchRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


resource "aws_iam_role_policy_attachment" "OSSearchRole_attachment2" {
  role       = aws_iam_role.mybookstore-OSSearchRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"


}

########################################################################

resource "aws_iam_role" "mybookstore-CodePipeline-Role" {
  path                 = "/"
  name                 = "mybookstore-CodePipeline-Role"
  assume_role_policy   = "{\"Version\":\"2008-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"codepipeline.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"
  max_session_duration = 3600
  tags                 = {}
}

resource "aws_iam_role" "mybookstore-SNSRole" {
  path                 = "/"
  name                 = "mybookstore-SNSRole"
  assume_role_policy   = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"cognito-idp.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"
  max_session_duration = 3600
  tags                 = {}
}

############################ mybookstore-CreateOSRole ####################

resource "aws_iam_role" "mybookstore-CreateOSRole" {
  path                 = "/"
  name                 = "mybookstore-CreateOSRole"
  assume_role_policy   = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"lambda.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"
  max_session_duration = 3600
  tags                 = {}
}


resource "aws_iam_role_policy_attachment" "CreateOSRole_attachment1" {
  role       = aws_iam_role.mybookstore-CreateOSRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"


}

############################## mybookstore-RedisRole #####################################

resource "aws_iam_role" "mybookstore-RedisRole" {
  path                 = "/"
  name                 = "mybookstore-RedisRole"
  assume_role_policy   = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"lambda.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"
  max_session_duration = 3600
  tags                 = {}
}

resource "aws_iam_role_policy_attachment" "RedisRole_attachment1" {
  role       = aws_iam_role.mybookstore-RedisRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonElastiCacheFullAccess"
}

resource "aws_iam_role_policy_attachment" "RedisRole_attachment2" {
  role       = aws_iam_role.mybookstore-RedisRole.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaInvocation-DynamoDB"
}

resource "aws_iam_role_policy_attachment" "RedisRole_attachment3" {
  role       = aws_iam_role.mybookstore-RedisRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}


################################# mybookstore-RecommendationsLambdaRole ####################################

resource "aws_iam_role" "mybookstore-RecommendationsLambdaRole" {
  path                 = "/"
  name                 = "mybookstore-RecommendationsLambdaRole"
  assume_role_policy   = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"lambda.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"
  max_session_duration = 3600
  tags                 = {}
}

resource "aws_iam_role_policy_attachment" "RecommendationsLambdaRole_attachment1" {
  role       = aws_iam_role.mybookstore-RecommendationsLambdaRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


################################ mybookstore-SeederRole ########################################

resource "aws_iam_role" "mybookstore-SeederRole" {
  path                 = "/"
  name                 = "mybookstore-SeederRole"
  assume_role_policy   = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"lambda.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"
  max_session_duration = 3600
  tags                 = {}
}


resource "aws_iam_role_policy_attachment" "SeederRole_attachment1" {
  role       = aws_iam_role.mybookstore-SeederRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}