# Creation of lambda function:

##################### mybookstore-UpdateSearchCluster ########################

resource "aws_lambda_function" "UpdateSearchCluster" {
  description = "Update OpenSearch cluster as books are added"
  environment {
    variables = {
      ESENDPOINT = data.aws_elasticsearch_domain.my_domain.endpoint
      REGION     = "us-east-1"
    }
  }
  function_name = "mybookstore-UpdateSearchCluster"
  handler       = "index.handler"
  architectures = [
    "x86_64"
  ]

  memory_size = 128
  role        = "arn:aws:iam::${var.account_id}:role/mybookstore-OSSearchRole"
  runtime     = "python3.9"
  timeout     = 60
  tracing_config {
    mode = "PassThrough"
  }
  vpc_config {
    subnet_ids = [
      aws_subnet.EC2Subnet1.id
    ]
    security_group_ids = [
      aws_security_group.custom_default_sg.id
    ]
  }

  depends_on = [
    aws_iam_role.mybookstore-OSSearchRole,
    aws_elasticsearch_domain.OpenSearchServiceDomain,
    aws_dynamodb_table.DynamoDBTable
  ]

  # source_code_hash = "lambda-function-code-repo/UpdateSearchCluster.zip"
  filename = "lambda-function-code-repo/UpdateSearchCluster.zip"
  #source_code_size = filemd5("UpdateSearchCluster.zip") * 1024

  tags = {
    Name = "mybookstore-UpdateSearchCluster"
  }
}


resource "aws_lambda_event_source_mapping" "DataTableStream1" {
  depends_on        = [aws_dynamodb_table.DynamoDBTable]
  batch_size        = 1
  enabled           = true
  event_source_arn  = aws_dynamodb_table.DynamoDBTable.stream_arn
  function_name     = aws_lambda_function.UpdateSearchCluster.arn
  starting_position = "TRIM_HORIZON"
}


#################### mybookstore-ListOrders ##################

resource "aws_lambda_function" "FunctionListOrders" {
  description = "Get list of books ordered by customerId"
  environment {
    variables = {
      TABLE_NAME = "mybookstore-Orders"
    }
  }
  function_name = "mybookstore-ListOrders"
  handler       = "index.handler"
  architectures = [
    "x86_64"
  ]

  # source_code_hash = "lambda-function-code-repo/ListOrders.zip"
  filename = "lambda-function-code-repo/ListOrders.zip"

  memory_size = 256
  role        = "arn:aws:iam::${var.account_id}:role/mybookstore-DynamoDbLambda"
  runtime     = "nodejs16.x"
  timeout     = 120
  tracing_config {
    mode = "PassThrough"
  }
  tags = {
    Name = "mybookstore-ListOrders"
  }
}

#### Permissions ###

resource "aws_lambda_permission" "LambdaPermission_ListOrders" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.FunctionListOrders.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.AppApi.execution_arn}/*"
}



################### mybookstore-GetBook ###################

resource "aws_lambda_function" "FunctionGetBook" {
  description = "Get book by id"
  environment {
    variables = {
      TABLE_NAME = "mybookstore-Books"
    }
  }
  function_name = "mybookstore-GetBook"
  handler       = "index.handler"
  architectures = [
    "x86_64"
  ]

  memory_size = 256
  role        = "arn:aws:iam::${var.account_id}:role/mybookstore-DynamoDbLambda"

  # source_code_hash = "lambda-function-code-repo/GetBook.zip"
  filename = "lambda-function-code-repo/GetBook.zip"

  runtime = "nodejs16.x"
  timeout = 120
  tracing_config {
    mode = "PassThrough"
  }
  tags = {
    Name = "mybookstore-GetBook"
  }
}

#### Permissions ####

resource "aws_lambda_permission" "LambdaPermission_GetBook" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.FunctionGetBook.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.AppApi.execution_arn}/*"
}


###################### ListBooks ######################


resource "aws_lambda_function" "FunctionListBooks" {
  description = "Get list of books by category"
  environment {
    variables = {
      TABLE_NAME = "mybookstore-Books"
    }
  }
  function_name = "mybookstore-ListBooks"
  handler       = "index.handler"
  architectures = [
    "x86_64"
  ]

  # source_code_hash = "lambda-function-code-repo/ListBooks.zip"
  filename = "lambda-function-code-repo/ListBooks.zip"

  memory_size = 256
  role        = "arn:aws:iam::${var.account_id}:role/mybookstore-DynamoDbLambda"
  runtime     = "nodejs16.x"
  timeout     = 120
  tracing_config {
    mode = "PassThrough"
  }
  tags = {
    Name = "mybookstore-ListBooks"
  }
}



resource "aws_lambda_permission" "LambdaPermission_ListBooks" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.FunctionListBooks.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.AppApi.execution_arn}/*"
}


####################### UpdateCart ########################


resource "aws_lambda_function" "FunctionUpdateCart" {
  description = "Update Customer's cart"
  environment {
    variables = {
      TABLE_NAME = "mybookstore-Cart"
    }
  }
  function_name = "mybookstore-UpdateCart"
  handler       = "index.handler"
  architectures = [
    "x86_64"
  ]

  # source_code_hash = "lambda-function-code-repo/UpdateCart.zip"
  filename = "lambda-function-code-repo/UpdateCart.zip"

  memory_size = 256
  role        = "arn:aws:iam::${var.account_id}:role/mybookstore-DynamoDbLambda"
  runtime     = "nodejs16.x"
  timeout     = 120
  tracing_config {
    mode = "PassThrough"
  }
  tags = {
    Name = "mybookstore-UpdateCart"
  }
}



resource "aws_lambda_permission" "LambdaPermission_UpdateCart" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.FunctionUpdateCart.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.AppApi.execution_arn}/*"
}




###################### GetCartItem ###########################

resource "aws_lambda_function" "FunctionGetCartItem" {
  description = "Get item in cart by customer and book id"
  environment {
    variables = {
      TABLE_NAME = "mybookstore-Cart"
    }
  }
  function_name = "mybookstore-GetCartItem"
  handler       = "index.handler"
  architectures = [
    "x86_64"
  ]

  # source_code_hash = "lambda-function-code-repo/GetCartItem.zip"
  filename = "lambda-function-code-repo/GetCartItem.zip"

  memory_size = 256
  role        = "arn:aws:iam::${var.account_id}:role/mybookstore-DynamoDbLambda"
  runtime     = "nodejs16.x"
  timeout     = 120
  tracing_config {
    mode = "PassThrough"
  }
  tags = {
    Name = "mybookstore-GetCartItem"
  }
}


resource "aws_lambda_permission" "LambdaPermission_GetCartItem" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.FunctionGetCartItem.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.AppApi.execution_arn}/*"
}



######################### FunctionListItemsInCart #######################

resource "aws_lambda_function" "FunctionListItemsInCart" {
  description = "Get list of items in cart"
  environment {
    variables = {
      TABLE_NAME = "mybookstore-Cart"
    }
  }
  function_name = "mybookstore-ListOrdersInCart"
  handler       = "index.handler"
  architectures = [
    "x86_64"
  ]

  # source_code_hash = "lambda-function-code-repo/ListItemsInCart.zip"
  filename = "lambda-function-code-repo/ListItemsInCart.zip"


  memory_size = 256
  role        = "arn:aws:iam::${var.account_id}:role/mybookstore-DynamoDbLambda"
  runtime     = "nodejs16.x"
  timeout     = 120
  tracing_config {
    mode = "PassThrough"
  }
  tags = {
    Name = "mybookstore-ListOrdersInCart"
  }
}


resource "aws_lambda_permission" "LambdaPermission_ListOrdersInCart" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.FunctionListItemsInCart.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.AppApi.execution_arn}/*"
}



######################## AddToCart ######################

resource "aws_lambda_function" "FunctionAddToCart" {
  description = "Add a book to cart"
  environment {
    variables = {
      TABLE_NAME = "mybookstore-Cart"
    }
  }
  function_name = "mybookstore-AddToCart"
  handler       = "index.handler"
  architectures = [
    "x86_64"
  ]

  # source_code_hash = "lambda-function-code-repo/AddToCart.zip"
  filename = "lambda-function-code-repo/AddToCart.zip"


  memory_size = 256
  role        = "arn:aws:iam::${var.account_id}:role/mybookstore-DynamoDbLambda"
  runtime     = "nodejs16.x"
  timeout     = 120
  tracing_config {
    mode = "PassThrough"
  }
  tags = {
    Name = "mybookstore-AddToCart"
  }
}


resource "aws_lambda_permission" "LambdaPermission_AddToCart" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.FunctionAddToCart.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.AppApi.execution_arn}/*"
}



######################## RemoveFromCart ########################


resource "aws_lambda_function" "FunctionRemoveFromCart" {
  description = "Remove a book from cart"
  environment {
    variables = {
      TABLE_NAME = "mybookstore-Cart"
    }
  }
  function_name = "mybookstore-RemoveFromCart"
  handler       = "index.handler"
  architectures = [
    "x86_64"
  ]

  # source_code_hash = "lambda-function-code-repo/RemoveFromCart.zip"
  filename    = "lambda-function-code-repo/RemoveFromCart.zip"
  memory_size = 256
  role        = "arn:aws:iam::${var.account_id}:role/mybookstore-DynamoDbLambda"
  runtime     = "nodejs16.x"
  timeout     = 120
  tracing_config {
    mode = "PassThrough"
  }
  tags = {
    Name = "mybookstore-RemoveFromCart"
  }
}


resource "aws_lambda_permission" "LambdaPermission_RemoveFromCart" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.FunctionRemoveFromCart.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.AppApi.execution_arn}/*"
}


######################### Checkout ##############################


resource "aws_lambda_function" "FunctionCheckout" {
  description = "Get list of books ordered by customerId"
  environment {
    variables = {
      CART_TABLE   = "mybookstore-Cart"
      ORDERS_TABLE = "mybookstore-Orders"
    }
  }
  function_name = "mybookstore-Checkout"
  handler       = "index.handler"
  architectures = [
    "x86_64"
  ]

  # source_code_hash = "lambda-function-code-repo/Checkout.zip"
  filename = "lambda-function-code-repo/Checkout.zip"

  memory_size = 256
  role        = "arn:aws:iam::${var.account_id}:role/mybookstore-DynamoDbLambda"
  runtime     = "nodejs16.x"
  timeout     = 120
  tracing_config {
    mode = "PassThrough"
  }
  tags = {
    Name = "mybookstore-Checkout"
  }
}


resource "aws_lambda_permission" "LambdaPermission_Checkout" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.FunctionCheckout.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.AppApi.execution_arn}/*"
}


####################### UploadBooks #####################

resource "aws_lambda_function" "FunctionUploadBooks" {
  description = "Upload sample data for books"
  environment {
    variables = {
      S3_BUCKET  = "aws-bookstore-demo-app-us-east-1"
      TABLE_NAME = "mybookstore-Books"
      FILE_NAME  = "data/books.json"
    }
  }
  function_name = "mybookstore-UploadBooks"
  handler       = "index.handler"
  architectures = [
    "x86_64"
  ]

  # source_code_hash = "lambda-function-code-repo/UploadBooks.zip"
  filename = "lambda-function-code-repo/UploadBooks.zip"


  memory_size = 128
  role        = "arn:aws:iam::${var.account_id}:role/mybookstore-DynamoDbLambda"
  runtime     = "nodejs16.x"
  timeout     = 120
  tracing_config {
    mode = "PassThrough"
  }
  tags = {
    Name = "mybookstore-UploadBooks"
  }
}


####################### GetRecommendations #####################

resource "aws_lambda_function" "FunctionGetRecommendations" {
  description = "Get the top 5 product recommendations from Neptune"
  environment {
    variables = {
      neptunedb = aws_neptune_cluster.NeptuneDBCluster.endpoint
    }
  }
  function_name = "mybookstore-GetRecommendations"
  handler       = "index.handler"
  architectures = [
    "x86_64"
  ]

  # source_code_hash = "lambda-function-code-repo/GetRecommendations.zip"
  filename = "lambda-function-code-repo/GetRecommendations.zip"


  memory_size = 256
  role        = "arn:aws:iam::${var.account_id}:role/mybookstore-RecommendationsLambdaRole"
  runtime     = "python3.9"
  timeout     = 30
  tracing_config {
    mode = "PassThrough"
  }
  vpc_config {
    subnet_ids = [
      aws_subnet.EC2Subnet1.id,
      aws_subnet.EC2Subnet2.id
    ]
    security_group_ids = [
      aws_security_group.neptunedb_sg.id
    ]
  }
  tags = {
    Name = "mybookstore-GetRecommendations"
  }
}


resource "aws_lambda_permission" "LambdaPermission_GetRecommendations" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.FunctionGetRecommendations.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.AppApi.execution_arn}/*"
}



######################## GetRecommendationsByBook #########################

resource "aws_lambda_function" "FunctionGetRecommendationsByBook" {
  description = "Get friends who purchased this book"
  environment {
    variables = {
      neptunedb = aws_neptune_cluster.NeptuneDBCluster.endpoint
    }
  }
  function_name = "mybookstore-GetRecommendationsByBook"
  handler       = "index.handler"
  architectures = [
    "x86_64"
  ]

  # source_code_hash = "lambda-function-code-repo/GetRecommendationsByBook.zip"
  filename = "lambda-function-code-repo/GetRecommendationsByBook.zip"


  memory_size = 256
  role        = "arn:aws:iam::${var.account_id}:role/mybookstore-RecommendationsLambdaRole"
  runtime     = "python3.9"
  timeout     = 30
  tracing_config {
    mode = "PassThrough"
  }
  vpc_config {
    subnet_ids = [
      aws_subnet.EC2Subnet1.id,
      aws_subnet.EC2Subnet2.id
    ]
    security_group_ids = [
      aws_security_group.neptunedb_sg.id
    ]
  }
  tags = {
    Name = "mybookstore-GetRecommendationsByBook"
  }
}



resource "aws_lambda_permission" "LambdaPermission_GetRecommendationsByBook" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.FunctionGetRecommendationsByBook.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.AppApi.execution_arn}/*"
}



##################### Search #######################

resource "aws_lambda_function" "FunctionSearch" {
  description = "Search for books across book names, authors, and categories"
  environment {
    variables = {
      ESENDPOINT = data.aws_elasticsearch_domain.my_domain.endpoint
      REGION     = var.region
    }
  }
  function_name = "mybookstore-Search"
  handler       = "index.handler"
  architectures = [
    "x86_64"
  ]

  # source_code_hash = "lambda-function-code-repo/Search.zip"
  filename = "lambda-function-code-repo/Search.zip"

  memory_size = 256
  role        = "arn:aws:iam::${var.account_id}:role/mybookstore-OSSearchRole"
  runtime     = "python3.8"
  timeout     = 60
  tracing_config {
    mode = "PassThrough"
  }
  vpc_config {
    subnet_ids = [
      aws_subnet.EC2Subnet1.id
    ]
    security_group_ids = [
      aws_security_group.custom_default_sg.id
    ]
  }
  layers = [
    aws_lambda_layer_version.PythonLambdaLayer.arn
  ]
  tags = {
    Name = "mybookstore-Search"
  }
}


resource "aws_lambda_permission" "LambdaPermission_Search" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.FunctionSearch.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.AppApi.execution_arn}/*"
}


########################### PythonLambdaLayer ####################

resource "aws_lambda_layer_version" "PythonLambdaLayer" {
  compatible_runtimes = ["python3.9", "python3.7", "python3.6"]
  layer_name          = "PythonLambdaLayer"
  # source_code_hash    = "lambda-function-code-repo/PythonLambdaLayer.zip"
  filename = "lambda-function-code-repo/PythonLambdaLayer.zip"

}


############################ GetBestSellers ###############################


resource "aws_lambda_function" "FunctionGetBestSellers" {
  description = "Get the top 20 best selling books from ElastiCache"
  environment {
    variables = {
      # URL = "mybookstore-cluster.o9uwnq.0001.use1.cache.amazonaws.com"
      URL = aws_elasticache_cluster.ElastiCacheCacheCluster.cache_nodes.0.address
    }
  }
  function_name = "mybookstore-GetBestSellers"
  handler       = "index.handler"
  architectures = [
    "x86_64"
  ]

  # source_code_hash = "lambda-function-code-repo/GetBestSellers.zip"
  filename = "lambda-function-code-repo/GetBestSellers.zip"

  memory_size = 256
  role        = "arn:aws:iam::${var.account_id}:role/mybookstore-RedisRole"
  runtime     = "nodejs16.x"
  timeout     = 60
  tracing_config {
    mode = "PassThrough"
  }
  vpc_config {
    subnet_ids = [
      aws_subnet.EC2Subnet1.id
    ]
    security_group_ids = [
      aws_security_group.redis_sg.id
    ]
  }
  tags = {
    Name = "mybookstore-GetBestSellers"
  }

  depends_on = [
    aws_iam_role.mybookstore-RedisRole,
    aws_elasticache_cluster.ElastiCacheCacheCluster,
    aws_dynamodb_table.DynamoDBTable3
  ]
}


resource "aws_lambda_permission" "LambdaPermission_GetBestSellers" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.FunctionGetBestSellers.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.AppApi.execution_arn}/*"
}


######################### mybookstore-BucketCleanup #####################

resource "aws_lambda_function" "BucketCleanup" {
  description   = "Cleanup S3 buckets when deleting stack"
  function_name = "mybookstore-BucketCleanup"
  handler       = "index.handler"
  architectures = [
    "x86_64"
  ]

  # source_code_hash = "lambda-function-code-repo/DeleteBuckets.zip"
  filename = "lambda-function-code-repo/DeleteBuckets.zip"

  memory_size = 256
  role        = "arn:aws:iam::${var.account_id}:role/mybookstore-BucketCleanupRole"
  runtime     = "python3.9"
  timeout     = 30
  tracing_config {
    mode = "PassThrough"
  }
  layers = [
    aws_lambda_layer_version.PythonLambdaLayer.arn
  ]
  tags = {}

}




################################# bookstoreNeptuneIAMAttachLambda ##############################

resource "aws_lambda_function" "bookstoreNeptuneIAMAttachLambda" {
  description = "Lambda function to add an IAM policy to a Neptune cluster to allow for bulk load."
  environment {
    variables = {
      neptunedb = aws_neptune_cluster.NeptuneDBCluster.endpoint
      iamrole   = aws_iam_role.mybookstore-bookstoreNeptuneLoaderS3ReadRole.arn
      region    = var.region
    }
  }
  function_name = "mybookstore-bookstoreNeptuneIAMAttachLambda"
  handler       = "lambda_function.lambda_handler"
  architectures = [
    "x86_64"
  ]

  # source_code_hash = "lambda-function-code-repo/NeptuneIAM.zip"
  filename = "lambda-function-code-repo/NeptuneIAM.zip"

  memory_size = 128
  role        = "arn:aws:iam::${var.account_id}:role/mybookstore-bookstoreNeptuneIAMAttachLambdaRole"
  runtime     = "python3.9"
  timeout     = 30
  tracing_config {
    mode = "PassThrough"
  }
  layers = [
    aws_lambda_layer_version.PythonLambdaLayer.arn
  ]
  tags = {
    Name = "mybookstore-bookstoreNeptuneIAMAttachLambda"
  }
}

########################### bookstoreNeptuneLoaderLambda #########################


resource "aws_lambda_function" "bookstoreNeptuneLoaderLambda" {
  description = "Lambda function to load data into Neptune instance."
  environment {
    variables = {
      neptunedb         = aws_neptune_cluster.NeptuneDBCluster.endpoint
      s3loadiamrole     = aws_iam_role.mybookstore-bookstoreNeptuneLoaderS3ReadRole.arn
      region            = var.region
      neptuneloads3path = "s3://bookstore-neptune/data/"
    }
  }
  function_name = "mybookstore-bookstoreNeptuneLoaderLambda"
  handler       = "lambda_function.lambda_handler"
  architectures = [
    "x86_64"
  ]

  # source_code_hash = "lambda-function-code-repo/NeptuneLoader.zip"
  filename = "lambda-function-code-repo/NeptuneLoader.zip"

  memory_size = 128
  role        = "arn:aws:iam::${var.account_id}:role/mybookstore-bookstoreNeptuneLoaderLambdaRole"
  runtime     = "python3.9"
  timeout     = 180
  tracing_config {
    mode = "PassThrough"
  }
  vpc_config {
    subnet_ids = [
      aws_subnet.EC2Subnet1.id,
      aws_subnet.EC2Subnet2.id
    ]
    security_group_ids = [
      aws_security_group.neptunedb_sg.id
    ]
  }
  layers = [
    aws_lambda_layer_version.PythonLambdaLayer.arn
  ]
  tags = {
    Name = "mybookstore-bookstoreNeptuneLoaderLambda"
  }
}


############################ UpdateBestSellers #######################

resource "aws_lambda_function" "UpdateBestSellers" {
  description = "Updates BestSellers as orders are placed"
  environment {
    variables = {
      URL = aws_elasticache_cluster.ElastiCacheCacheCluster.cache_nodes.0.address
    }
  }
  function_name = "mybookstore-UpdateBestSellers"
  handler       = "index.handler"
  architectures = [
    "x86_64"
  ]

  # source_code_hash = "lambda-function-code-repo/UpdateBestSellers.zip"
  filename = "lambda-function-code-repo/UpdateBestSellers.zip"

  memory_size = 128
  role        = "arn:aws:iam::${var.account_id}:role/mybookstore-RedisRole"
  runtime     = "nodejs16.x"
  timeout     = 60
  tracing_config {
    mode = "PassThrough"
  }
  vpc_config {
    subnet_ids = [
      aws_subnet.EC2Subnet1.id
    ]
    security_group_ids = [
      aws_security_group.redis_sg.id
    ]
  }
  tags = {
    Name = "mybookstore-UpdateBestSellers"
  }
}




resource "aws_lambda_event_source_mapping" "DataTableStream2" {
  depends_on        = [aws_dynamodb_table.DynamoDBTable3]
  batch_size        = 1
  enabled           = true
  event_source_arn  = aws_dynamodb_table.DynamoDBTable3.stream_arn
  function_name     = aws_lambda_function.UpdateBestSellers.arn
  starting_position = "TRIM_HORIZON"
}



########################## SeederFunction #######################

# resource "aws_lambda_function" "SeederFunction" {
#   function_name = "SeederFunction"
#   depends_on  = [aws_codecommit_repository.CodeCommitRepository]
#   description = "CodeCommit repository seeder"
#   handler     = "seeder.SeedRepositoryHandler"
#   memory_size = 3008
#   role        = aws_iam_role.mybookstore-SeederRole.arn
#   runtime     = "java8"
#   timeout     = 900


#   # source_code_hash = "lambda-function-code-repo/aws-serverless-codecommit-seeder.zip"
#   filename         = "lambda-function-code-repo/aws-serverless-codecommit-seeder.zip"
# }




############################### UpdateConfigFunction ##################################


resource "aws_lambda_function" "UpdateConfigFunction" {
  description = "Update config for CodeCommit repository"

  depends_on = [
    aws_codecommit_repository.CodeCommitRepository,
    #aws_lambda_function.SeederFunction,
    #aws_cloudformation_custom_resource.RepositorySeeder,
    aws_api_gateway_rest_api.AppApi,
    aws_cognito_user_pool.CognitoUserPool,
    aws_cognito_user_pool_client.CognitoUserPoolClient,
    aws_cognito_identity_pool.CognitoIdentityPool,
  ]

  function_name = "UpdateConfigFunction"

  handler = "index.handler"
  role    = aws_iam_role.mybookstore-SeederRole.arn
  runtime = "nodejs16.x"
  timeout = 300

  # source_code_hash = "lambda-function-code-repo/UpdateConfig.zip"
  filename = "lambda-function-code-repo/UpdateConfig.zip"
  #"https://${aws_api_gateway_rest_api.AppApi.id}.execute-api.${var.aws_region}.amazonaws.com/prod"
  environment {
    variables = {
      API_URL          = "https://${aws_api_gateway_rest_api.AppApi.id}.execute-api.${var.region}.amazonaws.com/prod"
      BRANCH_NAME      = "master"
      REGION           = var.region
      REPOSITORY_NAME  = aws_codecommit_repository.CodeCommitRepository.repository_name
      USER_POOL_ID     = aws_cognito_user_pool.CognitoUserPool.id
      APP_CLIENT_ID    = aws_cognito_user_pool_client.CognitoUserPoolClient.id
      IDENTITY_POOL_ID = aws_cognito_identity_pool.CognitoIdentityPool.id
    }
  }
}



########################### CreateOSRoleFunction #########################################

resource "aws_lambda_function" "CreateOSRoleFunction" {

  function_name = "CreateOSRoleFunction"
  description   = "Create OpenSearch role"
  handler       = "index.handler"
  role          = aws_iam_role.mybookstore-CreateOSRole.arn
  runtime       = "nodejs16.x"
  timeout       = 300

  # source_code_hash = "lambda-function-code-repo/CreateOSRole.zip"
  filename = "lambda-function-code-repo/CreateOSRole.zip"

}


# resource "aws_cloudformation_custom_resource" "RepositorySeeder" {
#   service_token             = aws_lambda_function.SeederFunction.arn
#   create_before_destroy     = true

#   properties = {
#     sourceUrl               = "lambda-function-code-repo/bookstore-webapp.zip"
#     targetRepositoryName    = aws_codecommit_repository.CodeCommitRepository.repository_name
#     targetRepositoryRegion  = var.region
#   }
# }

# Define other necessary resources and configurations
