################# Rest API gateway ###############

resource "aws_api_gateway_rest_api" "AppApi" {
  name        = "${var.ProjectName}-Bookstore"
  description = "API used for Bookstore requests"
  # fail_on_warnings = true
}


########### Recommendation API ###############

resource "aws_api_gateway_method" "RecomendationsApiRequestGET" {
  depends_on = [aws_lambda_function.FunctionGetRecommendations]

  authorization = "AWS_IAM"
  http_method   = "GET"
  rest_api_id   = aws_api_gateway_rest_api.AppApi.id
  resource_id   = aws_api_gateway_resource.RecommendationsApiResource.id

  # integration = {
  #   type                    = "AWS_PROXY"
  #   integration_http_method = "POST"
  #   uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.FunctionGetRecommendations.arn}/invocations"

  #   integration_responses = {
  #     status_code = 200
  #   }
  # }

  # method_responses = {
  #   status_code = 200

  #   response_models = {
  #     "application/json" = "Empty"
  #   }
  # }
}


resource "aws_api_gateway_integration" "RecomendationsApiRequestGET" {
  rest_api_id             = aws_api_gateway_rest_api.AppApi.id
  resource_id             = aws_api_gateway_resource.RecommendationsApiResource.id
  http_method             = aws_api_gateway_method.RecomendationsApiRequestGET.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.FunctionGetRecommendations.invoke_arn
}

resource "aws_api_gateway_integration_response" "RecomendationsApiRequestGET" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.RecommendationsApiResource.id
  http_method = aws_api_gateway_method.RecomendationsApiRequestGET.http_method
  status_code = aws_api_gateway_method_response.RecomendationsApiRequestGET.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'https://${aws_cloudfront_distribution.CloudFrontDistribution.domain_name}'"
  }

}

resource "aws_api_gateway_method_response" "RecomendationsApiRequestGET" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.RecommendationsApiResource.id
  http_method = aws_api_gateway_method.RecomendationsApiRequestGET.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = false
  }
}


#################################################################################################



resource "aws_api_gateway_method" "RecomendationsApiRequestOPTIONS" {
  rest_api_id   = aws_api_gateway_rest_api.AppApi.id
  resource_id   = aws_api_gateway_resource.RecommendationsApiResource.id
  authorization = "NONE"
  http_method   = "OPTIONS"

  # integration = {
  #   type = "MOCK"

  #   integration_responses = {
  #     status_code = "200"

  #     response_parameters = {
  #       "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
  #       "method.response.header.Access-Control-Allow-Methods" = "'''GET,POST,PUT,DELETE,OPTIONS,HEAD,PATCH'''"
  #       "method.response.header.Access-Control-Allow-Origin"  = "'https://${aws_cloudfront_distribution.CloudFrontDistribution.domain_name}'"
  #     }

  #     response_templates = {
  #       "application/json" = ""
  #     }
  #   }

  #   passthrough_behavior = "WHEN_NO_MATCH"

  #   request_templates = {
  #     "application/json" = "{\"statusCode\": 200}"
  #   }
  # }

  # method_responses = {
  #   status_code = "200"

  #   response_models = {
  #     "application/json" = "Empty"
  #   }

  #   response_parameters = {
  #     "method.response.header.Access-Control-Allow-Headers" = true
  #     "method.response.header.Access-Control-Allow-Methods" = true
  #     "method.response.header.Access-Control-Allow-Origin"  = true
  #   }
  # }
}


resource "aws_api_gateway_integration" "RecomendationsApiRequestOPTIONS" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.RecommendationsApiResource.id
  http_method = aws_api_gateway_method.RecomendationsApiRequestOPTIONS.http_method
  #integration_http_method = "POST"
  type = "MOCK"


  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration_response" "RecomendationsApiRequestOPTIONS" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.RecommendationsApiResource.id
  http_method = aws_api_gateway_method.RecomendationsApiRequestOPTIONS.http_method
  status_code = aws_api_gateway_method_response.RecomendationsApiRequestOPTIONS.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'https://${aws_cloudfront_distribution.CloudFrontDistribution.domain_name}'"
  }

  response_templates = {
    "application/json" = ""
  }
}

resource "aws_api_gateway_method_response" "RecomendationsApiRequestOPTIONS" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.RecommendationsApiResource.id
  http_method = aws_api_gateway_method.RecomendationsApiRequestOPTIONS.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = false
    "method.response.header.Access-Control-Allow-Methods" = false
    "method.response.header.Access-Control-Allow-Origin"  = false
  }
}



############################################################################################





resource "aws_api_gateway_method" "RecomendationsByBookApiRequestGET" {
  depends_on    = [aws_lambda_function.FunctionGetRecommendationsByBook]
  authorization = "AWS_IAM"
  http_method   = "GET"
  rest_api_id   = aws_api_gateway_rest_api.AppApi.id
  resource_id   = aws_api_gateway_resource.RecommendationsByBookApiResource.id

  # integration = {
  #   type                    = "AWS_PROXY"
  #   integration_http_method = "POST"
  #   uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.FunctionGetRecommendationsByBook.arn}/invocations"

  #   integration_responses = {
  #     status_code = 200
  #   }
  # }

  request_parameters = {
    "method.request.path.bookId" = false
  }

  # method_responses = {
  #   status_code = 200

  #   response_models = {
  #     "application/json" = "Empty"
  #   }
  # }
}




resource "aws_api_gateway_integration" "RecomendationsByBookApiRequestGET" {
  rest_api_id             = aws_api_gateway_rest_api.AppApi.id
  resource_id             = aws_api_gateway_resource.RecommendationsByBookApiResource.id
  http_method             = aws_api_gateway_method.RecomendationsByBookApiRequestGET.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.FunctionGetRecommendationsByBook.invoke_arn

  # request_parameters = {
  #   "method.request.path.bookId" = false
  #   #"integration.request.path.bookId" = "method.request.path.bookId"
  # }
}

resource "aws_api_gateway_integration_response" "RecomendationsByBookApiRequestGET" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.RecommendationsByBookApiResource.id
  http_method = aws_api_gateway_method.RecomendationsByBookApiRequestGET.http_method
  status_code = aws_api_gateway_method_response.RecomendationsByBookApiRequestGET.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'https://${aws_cloudfront_distribution.CloudFrontDistribution.domain_name}'"
  }

}

resource "aws_api_gateway_method_response" "RecomendationsByBookApiRequestGET" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.RecommendationsByBookApiResource.id
  http_method = aws_api_gateway_method.RecomendationsByBookApiRequestGET.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = false
  }
}





#################################################################################################

resource "aws_api_gateway_method" "RecomendationsByBookApiRequestOPTIONS" {
  rest_api_id   = aws_api_gateway_rest_api.AppApi.id
  resource_id   = aws_api_gateway_resource.RecommendationsByBookApiResource.id
  authorization = "NONE"
  http_method   = "OPTIONS"

  # integration = {
  #   type = "MOCK"

  #   integration_responses = {
  #     status_code = "200"

  #     response_parameters = {
  #       "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
  #       "method.response.header.Access-Control-Allow-Methods" = "'''GET,POST,PUT,DELETE,OPTIONS,HEAD,PATCH'''"
  #       "method.response.header.Access-Control-Allow-Origin"  = "'https://${aws_cloudfront_distribution.CloudFrontDistribution.domain_name}'"
  #     }

  #     response_templates = {
  #       "application/json" = ""
  #     }
  #   }

  #   passthrough_behavior = "WHEN_NO_MATCH"

  #   request_templates = {
  #     "application/json" = "{\"statusCode\": 200}"
  #   }
  # }

  # method_responses = {
  #   status_code = "200"

  #   response_models = {
  #     "application/json" = "Empty"
  #   }

  #   response_parameters = {
  #     "method.response.header.Access-Control-Allow-Headers" = true
  #     "method.response.header.Access-Control-Allow-Methods" = true
  #     "method.response.header.Access-Control-Allow-Origin"  = true
  #   }
  # }
}




resource "aws_api_gateway_integration" "RecomendationsByBookApiRequestOPTIONS" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.RecommendationsByBookApiResource.id
  http_method = aws_api_gateway_method.RecomendationsByBookApiRequestOPTIONS.http_method
  type        = "MOCK"

  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration_response" "RecomendationsByBookApiRequestOPTIONS" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.RecommendationsByBookApiResource.id
  http_method = aws_api_gateway_method.RecomendationsByBookApiRequestOPTIONS.http_method
  status_code = aws_api_gateway_method_response.RecomendationsByBookApiRequestOPTIONS.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'https://${aws_cloudfront_distribution.CloudFrontDistribution.domain_name}'"
  }

  response_templates = {
    "application/json" = ""
  }

}

resource "aws_api_gateway_method_response" "RecomendationsByBookApiRequestOPTIONS" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.RecommendationsByBookApiResource.id
  http_method = aws_api_gateway_method.RecomendationsByBookApiRequestOPTIONS.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = false
    "method.response.header.Access-Control-Allow-Methods" = false
    "method.response.header.Access-Control-Allow-Origin"  = false
  }

}




#################################################################################################



resource "aws_api_gateway_resource" "RecommendationsApiResource" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  parent_id   = aws_api_gateway_rest_api.AppApi.root_resource_id
  path_part   = "recommendations"
}


resource "aws_api_gateway_resource" "RecommendationsByBookApiResource" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  parent_id   = aws_api_gateway_resource.RecommendationsApiResource.id
  path_part   = "{bookId}"
}

##################################### book api ###################################


resource "aws_api_gateway_method" "BooksApiRequestGET" {
  depends_on    = [aws_lambda_function.FunctionListBooks]
  authorization = "AWS_IAM"
  http_method   = "GET"
  rest_api_id   = aws_api_gateway_rest_api.AppApi.id
  resource_id   = aws_api_gateway_resource.BooksApiResource.id

  # integration = {
  #   type                    = "AWS_PROXY"
  #   integration_http_method = "POST"
  #   uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.FunctionListBooks.arn}/invocations"

  #   integration_responses = {
  #     status_code = 200
  #   }
  # }

  request_parameters = {
    "method.request.querystring.category" = false
  }

  # method_responses = {
  #   status_code = 200

  #   response_models = {
  #     "application/json" = "Empty"
  #   }
  # }
}


resource "aws_api_gateway_integration" "BooksApiRequestGET" {
  rest_api_id             = aws_api_gateway_rest_api.AppApi.id
  resource_id             = aws_api_gateway_resource.BooksApiResource.id
  http_method             = aws_api_gateway_method.BooksApiRequestGET.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.FunctionListBooks.invoke_arn

  # request_parameters = {
  #   #"method.request.querystring.category" = false
  #   "integration.request.querystring.category" = "method.request.querystring.category"
  # }
}

resource "aws_api_gateway_integration_response" "BooksApiRequestGET" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.BooksApiResource.id
  http_method = aws_api_gateway_method.BooksApiRequestGET.http_method
  status_code = aws_api_gateway_method_response.BooksApiRequestGET.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'https://${aws_cloudfront_distribution.CloudFrontDistribution.domain_name}'"
  }

}

resource "aws_api_gateway_method_response" "BooksApiRequestGET" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.BooksApiResource.id
  http_method = aws_api_gateway_method.BooksApiRequestGET.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = false
  }
}

###################################################################################################
resource "aws_api_gateway_method" "BooksApiRequestOPTIONS" {
  rest_api_id   = aws_api_gateway_rest_api.AppApi.id
  resource_id   = aws_api_gateway_resource.BooksApiResource.id
  authorization = "NONE"
  http_method   = "OPTIONS"

  # integration = {
  #   type = "MOCK"

  #   integration_responses = {
  #     status_code = "200"

  #     response_parameters = {
  #       "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
  #       "method.response.header.Access-Control-Allow-Methods" = "'''GET,POST,PUT,DELETE,OPTIONS,HEAD,PATCH'''"
  #       "method.response.header.Access-Control-Allow-Origin"  = "'https://${aws_cloudfront_distribution.CloudFrontDistribution.domain_name}'"
  #     }

  #     response_templates = {
  #       "application/json" = ""
  #     }
  #   }

  #   passthrough_behavior = "WHEN_NO_MATCH"

  #   request_templates = {
  #     "application/json" = "{\"statusCode\": 200}"
  #   }
  # }

  # method_responses = {
  #   status_code = "200"

  #   response_models = {
  #     "application/json" = "Empty"
  #   }

  #   response_parameters = {
  #     "method.response.header.Access-Control-Allow-Headers" = true
  #     "method.response.header.Access-Control-Allow-Methods" = true
  #     "method.response.header.Access-Control-Allow-Origin"  = true
  #   }
  # }
}

resource "aws_api_gateway_integration" "BooksApiRequestOPTIONS" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.BooksApiResource.id
  http_method = aws_api_gateway_method.BooksApiRequestOPTIONS.http_method
  type        = "MOCK"

  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

}

resource "aws_api_gateway_integration_response" "BooksApiRequestOPTIONS" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.BooksApiResource.id
  http_method = aws_api_gateway_method.BooksApiRequestOPTIONS.http_method
  status_code = aws_api_gateway_method_response.BooksApiRequestOPTIONS.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'https://${aws_cloudfront_distribution.CloudFrontDistribution.domain_name}'"
  }

  response_templates = {
    "application/json" = ""
  }

}

resource "aws_api_gateway_method_response" "BooksApiRequestOPTIONS" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.BooksApiResource.id
  http_method = aws_api_gateway_method.BooksApiRequestOPTIONS.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = false
    "method.response.header.Access-Control-Allow-Methods" = false
    "method.response.header.Access-Control-Allow-Origin"  = false
  }
}

##################################################################################################

resource "aws_api_gateway_method" "BookItemApiRequestGET" {
  depends_on    = [aws_lambda_function.FunctionGetBook]
  authorization = "AWS_IAM"
  http_method   = "GET"
  rest_api_id   = aws_api_gateway_rest_api.AppApi.id
  resource_id   = aws_api_gateway_resource.BookItemApiResource.id

  # integration = {
  #   type                    = "AWS_PROXY"
  #   integration_http_method = "POST"
  #   uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.FunctionGetBook.arn}/invocations"

  #   integration_responses = {
  #     status_code = 200
  #     response_templates = {
  #       "application/json" = "$input.json('$.body')"
  #     }
  #   }
  # }

  request_parameters = {
    "method.request.path.id" = true
  }

  # method_responses = {
  #   status_code = 200
  #   response_models = {
  #     "application/json" = "Empty"
  #   }
  # }
}


resource "aws_api_gateway_integration" "BookItemApiRequestGET" {
  rest_api_id             = aws_api_gateway_rest_api.AppApi.id
  resource_id             = aws_api_gateway_resource.BookItemApiResource.id
  http_method             = aws_api_gateway_method.BookItemApiRequestGET.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.FunctionGetBook.invoke_arn

  # request_parameters = {
  #   #"method.request.path.id" = true
  #   "integration.request.path.id" = "method.request.path.id"
  # }
}

resource "aws_api_gateway_integration_response" "BookItemApiRequestGET" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.BookItemApiResource.id
  http_method = aws_api_gateway_method.BookItemApiRequestGET.http_method
  status_code = aws_api_gateway_method_response.BookItemApiRequestGET.status_code

  response_templates = {
    "application/json" = "$input.json('$.body')"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'https://${aws_cloudfront_distribution.CloudFrontDistribution.domain_name}'"
  }
}

resource "aws_api_gateway_method_response" "BookItemApiRequestGET" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.BookItemApiResource.id
  http_method = aws_api_gateway_method.BookItemApiRequestGET.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = false
  }
}


#############################################################################################


resource "aws_api_gateway_method" "BookItemApiRequestOPTIONS" {
  rest_api_id   = aws_api_gateway_rest_api.AppApi.id
  resource_id   = aws_api_gateway_resource.BookItemApiResource.id
  authorization = "NONE"
  http_method   = "OPTIONS"

  # integration = {
  #   type = "MOCK"

  #   integration_responses = {
  #     status_code = "200"

  #     response_parameters = {
  #       "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
  #       "method.response.header.Access-Control-Allow-Methods" = "'''GET,POST,PUT,DELETE,OPTIONS,HEAD,PATCH'''"
  #       "method.response.header.Access-Control-Allow-Origin"  = "'https://${aws_cloudfront_distribution.CloudFrontDistribution.domain_name}'"
  #     }

  #     response_templates = {
  #       "application/json" = ""
  #     }
  #   }

  #   passthrough_behavior = "WHEN_NO_MATCH"

  #   request_templates = {
  #     "application/json" = "{\"statusCode\": 200}"
  #   }
  # }

  # method_responses = {
  #   status_code = "200"

  #   response_models = {
  #     "application/json" = "Empty"
  #   }

  #   response_parameters = {
  #     "method.response.header.Access-Control-Allow-Headers" = true
  #     "method.response.header.Access-Control-Allow-Methods" = true
  #     "method.response.header.Access-Control-Allow-Origin"  = true
  #   }
  # }
}


resource "aws_api_gateway_integration" "BookItemApiRequestOPTIONS" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.BookItemApiResource.id
  http_method = aws_api_gateway_method.BookItemApiRequestOPTIONS.http_method
  type        = "MOCK"

  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration_response" "BookItemApiRequestOPTIONS" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.BookItemApiResource.id
  http_method = aws_api_gateway_method.BookItemApiRequestOPTIONS.http_method
  status_code = aws_api_gateway_method_response.BookItemApiRequestOPTIONS.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'https://${aws_cloudfront_distribution.CloudFrontDistribution.domain_name}'"
  }

  response_templates = {
    "application/json" = ""
  }

}

resource "aws_api_gateway_method_response" "BookItemApiRequestOPTIONS" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.BookItemApiResource.id
  http_method = aws_api_gateway_method.BookItemApiRequestOPTIONS.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = false
    "method.response.header.Access-Control-Allow-Methods" = false
    "method.response.header.Access-Control-Allow-Origin"  = false
  }
}

################################################################################################


resource "aws_api_gateway_resource" "BooksApiResource" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  parent_id   = aws_api_gateway_rest_api.AppApi.root_resource_id
  path_part   = "books"

}


resource "aws_api_gateway_resource" "BookItemApiResource" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  parent_id   = aws_api_gateway_resource.BooksApiResource.id
  path_part   = "{id}"

}

####################### Order API ###########################

resource "aws_api_gateway_method" "OrdersApiRequestGET" {
  depends_on    = [aws_lambda_function.FunctionListOrders]
  authorization = "AWS_IAM"
  http_method   = "GET"
  rest_api_id   = aws_api_gateway_rest_api.AppApi.id
  resource_id   = aws_api_gateway_resource.OrdersApiResource.id

  # integration = {
  #   type                    = "AWS_PROXY"
  #   integration_http_method = "POST"
  #   uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.FunctionListOrders.arn}/invocations"

  #   integration_responses = {
  #     status_code = 200
  #   }
  # }

  # method_responses = {
  #   status_code = 200
  #   response_models = {
  #     "application/json" = "Empty"
  #   }
  # }
}


resource "aws_api_gateway_integration" "OrdersApiRequestGET" {
  rest_api_id             = aws_api_gateway_rest_api.AppApi.id
  resource_id             = aws_api_gateway_resource.OrdersApiResource.id
  http_method             = aws_api_gateway_method.OrdersApiRequestGET.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.FunctionListOrders.invoke_arn
}

resource "aws_api_gateway_integration_response" "OrdersApiRequestGET" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.OrdersApiResource.id
  http_method = aws_api_gateway_method.OrdersApiRequestGET.http_method
  status_code = aws_api_gateway_method_response.OrdersApiRequestGET.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'https://${aws_cloudfront_distribution.CloudFrontDistribution.domain_name}'"
  }

}

resource "aws_api_gateway_method_response" "OrdersApiRequestGET" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.OrdersApiResource.id
  http_method = aws_api_gateway_method.OrdersApiRequestGET.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = false
  }
}


#####################################################################################

resource "aws_api_gateway_method" "OrdersApiRequestPOST" {
  depends_on    = [aws_lambda_function.FunctionCheckout]
  authorization = "AWS_IAM"
  http_method   = "POST"
  rest_api_id   = aws_api_gateway_rest_api.AppApi.id
  resource_id   = aws_api_gateway_resource.OrdersApiResource.id

  # integration = {
  #   type                    = "AWS_PROXY"
  #   integration_http_method = "POST"
  #   uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.FunctionCheckout.arn}/invocations"

  #   integration_responses = {
  #     status_code = 200
  #   }
  # }

  # method_responses = {
  #   status_code = 200
  #   response_models = {
  #     "application/json" = "Empty"
  #   }
  # }
}



resource "aws_api_gateway_integration" "OrdersApiRequestPOST" {
  rest_api_id             = aws_api_gateway_rest_api.AppApi.id
  resource_id             = aws_api_gateway_resource.OrdersApiResource.id
  http_method             = aws_api_gateway_method.OrdersApiRequestPOST.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.FunctionCheckout.invoke_arn
}

resource "aws_api_gateway_integration_response" "OrdersApiRequestPOST" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.OrdersApiResource.id
  http_method = aws_api_gateway_method.OrdersApiRequestPOST.http_method
  status_code = aws_api_gateway_method_response.OrdersApiRequestPOST.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'https://${aws_cloudfront_distribution.CloudFrontDistribution.domain_name}'"
  }

}

resource "aws_api_gateway_method_response" "OrdersApiRequestPOST" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.OrdersApiResource.id
  http_method = aws_api_gateway_method.OrdersApiRequestPOST.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = false
  }
}

######################################################################################


resource "aws_api_gateway_method" "OrdersApiRequestOPTIONS" {
  rest_api_id   = aws_api_gateway_rest_api.AppApi.id
  resource_id   = aws_api_gateway_resource.OrdersApiResource.id
  authorization = "NONE"
  http_method   = "OPTIONS"

  #   integration = {
  #     type = "MOCK"

  #     integration_responses = {
  #       status_code = "200"

  #       response_parameters = {
  #         "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
  #         "method.response.header.Access-Control-Allow-Methods" = "'''GET,POST,PUT,DELETE,OPTIONS,HEAD,PATCH'''"
  #         "method.response.header.Access-Control-Allow-Origin"  = "'https://${aws_cloudfront_distribution.CloudFrontDistribution.domain_name}'"
  #       }

  #       response_templates = {
  #         "application/json" = ""
  #       }
  #     }

  #     passthrough_behavior = "WHEN_NO_MATCH"

  #     request_templates = {
  #       "application/json" = "{\"statusCode\": 200}"
  #     }
  #   }

  #   method_responses = {
  #     status_code = "200"

  #     response_models = {
  #       "application/json" = "Empty"
  #     }

  #     response_parameters = {
  #       "method.response.header.Access-Control-Allow-Headers" = true
  #       "method.response.header.Access-Control-Allow-Methods" = true
  #       "method.response.header.Access-Control-Allow-Origin"  = true
  #     }
  #   }
}


resource "aws_api_gateway_integration" "OrdersApiRequestOPTIONS" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.OrdersApiResource.id
  http_method = aws_api_gateway_method.OrdersApiRequestOPTIONS.http_method
  type        = "MOCK"

  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration_response" "OrdersApiRequestOPTIONS" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.OrdersApiResource.id
  http_method = aws_api_gateway_method.OrdersApiRequestOPTIONS.http_method
  status_code = aws_api_gateway_method_response.OrdersApiRequestOPTIONS.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST'"
    "method.response.header.Access-Control-Allow-Origin"  = "'https://${aws_cloudfront_distribution.CloudFrontDistribution.domain_name}'"
  }

  response_templates = {
    "application/json" = ""
  }
}

resource "aws_api_gateway_method_response" "OrdersApiRequestOPTIONS" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.OrdersApiResource.id
  http_method = aws_api_gateway_method.OrdersApiRequestOPTIONS.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = false
    "method.response.header.Access-Control-Allow-Methods" = false
    "method.response.header.Access-Control-Allow-Origin"  = false
  }
}



#########################################################################################

resource "aws_api_gateway_resource" "OrdersApiResource" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  parent_id   = aws_api_gateway_rest_api.AppApi.root_resource_id
  path_part   = "orders"
}

######################## cart API ###########################

resource "aws_api_gateway_method" "CartApiRequestGET" {
  depends_on    = [aws_lambda_function.FunctionListItemsInCart]
  authorization = "AWS_IAM"
  http_method   = "GET"
  rest_api_id   = aws_api_gateway_rest_api.AppApi.id
  resource_id   = aws_api_gateway_resource.CartApiResource.id

  # integration = {
  #   type                    = "AWS_PROXY"
  #   integration_http_method = "POST"
  #   uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.FunctionListItemsInCart.arn}/invocations"

  #   integration_responses = {
  #     status_code = 200
  #   }
  # }

  # method_responses = {
  #   status_code = 200
  #   response_models = {
  #     "application/json" = "Empty"
  #   }
}

resource "aws_api_gateway_integration" "CartApiRequestGET" {
  rest_api_id             = aws_api_gateway_rest_api.AppApi.id
  resource_id             = aws_api_gateway_resource.CartApiResource.id
  http_method             = aws_api_gateway_method.CartApiRequestGET.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.FunctionListItemsInCart.invoke_arn


}

resource "aws_api_gateway_integration_response" "CartApiRequestGET" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.CartApiResource.id
  http_method = aws_api_gateway_method.CartApiRequestGET.http_method
  status_code = aws_api_gateway_method_response.CartApiRequestGET.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'https://${aws_cloudfront_distribution.CloudFrontDistribution.domain_name}'"
  }

}

resource "aws_api_gateway_method_response" "CartApiRequestGET" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.CartApiResource.id
  http_method = aws_api_gateway_method.CartApiRequestGET.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = false
  }
}



resource "aws_api_gateway_method" "CartApiRequestPOST" {
  depends_on    = [aws_lambda_function.FunctionAddToCart]
  authorization = "AWS_IAM"
  http_method   = "POST"
  rest_api_id   = aws_api_gateway_rest_api.AppApi.id
  resource_id   = aws_api_gateway_resource.CartApiResource.id

  # integration = {
  #   type                    = "AWS_PROXY"
  #   integration_http_method = "POST"
  #   uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.FunctionAddToCart.arn}/invocations"

  #   integration_responses = {
  #     status_code = 200
  #   }
  # }

  # method_responses = {
  #   status_code = 200
  #   response_models = {
  #     "application/json" = "Empty"
  #   }
  # }
}

resource "aws_api_gateway_integration" "CartApiRequestPOST" {
  rest_api_id             = aws_api_gateway_rest_api.AppApi.id
  resource_id             = aws_api_gateway_resource.CartApiResource.id
  http_method             = aws_api_gateway_method.CartApiRequestPOST.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.FunctionAddToCart.invoke_arn


}

resource "aws_api_gateway_integration_response" "CartApiRequestPOST" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.CartApiResource.id
  http_method = aws_api_gateway_method.CartApiRequestPOST.http_method
  status_code = aws_api_gateway_method_response.CartApiRequestPOST.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'https://${aws_cloudfront_distribution.CloudFrontDistribution.domain_name}'"
  }

}

resource "aws_api_gateway_method_response" "CartApiRequestPOST" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.CartApiResource.id
  http_method = aws_api_gateway_method.CartApiRequestPOST.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = false
  }
}





resource "aws_api_gateway_method" "CartApiRequestPUT" {
  depends_on    = [aws_lambda_function.FunctionUpdateCart]
  authorization = "AWS_IAM"
  http_method   = "PUT"
  rest_api_id   = aws_api_gateway_rest_api.AppApi.id
  resource_id   = aws_api_gateway_resource.CartApiResource.id

  # integration = {
  #   type                    = "AWS_PROXY"
  #   integration_http_method = "POST"
  #   uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.FunctionUpdateCart.arn}/invocations"

  #   integration_responses = {
  #     status_code = 200
  #   }
  # }

  # method_responses = {
  #   status_code = 200
  #   response_models = {
  #     "application/json" = "Empty"
  #   }
  # }
}

resource "aws_api_gateway_integration" "CartApiRequestPUT" {
  rest_api_id             = aws_api_gateway_rest_api.AppApi.id
  resource_id             = aws_api_gateway_resource.CartApiResource.id
  http_method             = aws_api_gateway_method.CartApiRequestPUT.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.FunctionUpdateCart.invoke_arn


}

resource "aws_api_gateway_integration_response" "CartApiRequestPUT" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.CartApiResource.id
  http_method = aws_api_gateway_method.CartApiRequestPUT.http_method
  status_code = aws_api_gateway_method_response.CartApiRequestPUT.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'https://${aws_cloudfront_distribution.CloudFrontDistribution.domain_name}'"
  }

}

resource "aws_api_gateway_method_response" "CartApiRequestPUT" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.CartApiResource.id
  http_method = aws_api_gateway_method.CartApiRequestPUT.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = false
  }
}



resource "aws_api_gateway_method" "CartApiRequestDELETE" {
  depends_on    = [aws_lambda_function.FunctionRemoveFromCart]
  authorization = "AWS_IAM"
  http_method   = "DELETE"
  rest_api_id   = aws_api_gateway_rest_api.AppApi.id
  resource_id   = aws_api_gateway_resource.CartApiResource.id

  # integration = {
  #   type                    = "AWS_PROXY"
  #   integration_http_method = "POST"
  #   uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.FunctionRemoveFromCart.arn}/invocations"

  #   integration_responses = {
  #     status_code = 200
  #   }
  # }

  request_parameters = {
    "method.request.path.id" = true
  }

  # method_responses = {
  #   status_code = 200
  #   response_models = {
  #     "application/json" = "Empty"
  #   }
  # }
}

resource "aws_api_gateway_integration" "CartApiRequestDELETE" {
  rest_api_id             = aws_api_gateway_rest_api.AppApi.id
  resource_id             = aws_api_gateway_resource.CartApiResource.id
  http_method             = aws_api_gateway_method.CartApiRequestDELETE.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.FunctionRemoveFromCart.invoke_arn


}

resource "aws_api_gateway_integration_response" "CartApiRequestDELETE" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.CartApiResource.id
  http_method = aws_api_gateway_method.CartApiRequestDELETE.http_method
  status_code = aws_api_gateway_method_response.CartApiRequestDELETE.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'https://${aws_cloudfront_distribution.CloudFrontDistribution.domain_name}'"
  }

}

resource "aws_api_gateway_method_response" "CartApiRequestDELETE" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.CartApiResource.id
  http_method = aws_api_gateway_method.CartApiRequestDELETE.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = false
  }
}


###############################

resource "aws_api_gateway_method" "CartApiRequestOPTIONS" {
  rest_api_id   = aws_api_gateway_rest_api.AppApi.id
  resource_id   = aws_api_gateway_resource.CartApiResource.id
  authorization = "NONE"
  http_method   = "OPTIONS"

  # integration = {
  #   type = "MOCK"

  #   integration_responses = {
  #     status_code = "200"

  #     response_parameters = {
  #       "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
  #       "method.response.header.Access-Control-Allow-Methods" = "'''GET,POST,PUT,DELETE,OPTIONS,HEAD,PATCH'''"
  #       "method.response.header.Access-Control-Allow-Origin"  = "'https://${aws_cloudfront_distribution.CloudFrontDistribution.domain_name}'"
  #     }

  #     response_templates = {
  #       "application/json" = ""
  #     }
  #   }

  #   passthrough_behavior = "WHEN_NO_MATCH"

  #   request_templates = {
  #     "application/json" = "{\"statusCode\": 200}"
  #   }
  # }

  # method_responses = {
  #   status_code = "200"

  #   response_models = {
  #     "application/json" = "Empty"
  #   }

  #   response_parameters = {
  #     "method.response.header.Access-Control-Allow-Headers" = true
  #     "method.response.header.Access-Control-Allow-Methods" = true
  #     "method.response.header.Access-Control-Allow-Origin"  = true
  #   }
  # }
}

resource "aws_api_gateway_integration" "CartApiRequestOPTIONS" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.CartApiResource.id
  http_method = aws_api_gateway_method.CartApiRequestOPTIONS.http_method
  type        = "MOCK"

  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration_response" "CartApiRequestOPTIONS" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.CartApiResource.id
  http_method = aws_api_gateway_method.CartApiRequestOPTIONS.http_method
  status_code = aws_api_gateway_method_response.CartApiRequestOPTIONS.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,OPTIONS,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'https://${aws_cloudfront_distribution.CloudFrontDistribution.domain_name}'"
  }

  response_templates = {
    "application/json" = ""
  }

}

resource "aws_api_gateway_method_response" "CartApiRequestOPTIONS" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.CartApiResource.id
  http_method = aws_api_gateway_method.CartApiRequestOPTIONS.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = false
    "method.response.header.Access-Control-Allow-Methods" = false
    "method.response.header.Access-Control-Allow-Origin"  = false
  }
}

##################################


#####################################

resource "aws_api_gateway_method" "CartItemApiRequestGET" {
  depends_on    = [aws_lambda_function.FunctionGetCartItem]
  authorization = "AWS_IAM"
  http_method   = "GET"
  rest_api_id   = aws_api_gateway_rest_api.AppApi.id
  resource_id   = aws_api_gateway_resource.CartItemApiResource.id

  # integration = {
  #   type                    = "AWS_PROXY"
  #   integration_http_method = "POST"
  #   uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.FunctionGetCartItem.arn}/invocations"

  #   integration_responses = {
  #     status_code = 200
  #   }
  # }

  request_parameters = {
    "method.request.path.bookId" = true
  }

  # method_responses = {
  #   status_code = 200
  #   response_models = {
  #     "application/json" = "Empty"
  #   }
  # }
}

resource "aws_api_gateway_integration" "CartItemApiRequestGET" {
  rest_api_id             = aws_api_gateway_rest_api.AppApi.id
  resource_id             = aws_api_gateway_resource.CartItemApiResource.id
  http_method             = aws_api_gateway_method.CartItemApiRequestGET.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.FunctionGetCartItem.invoke_arn

  # request_parameters = {
  #   "method.request.path.bookId" = true
  # }
}

resource "aws_api_gateway_integration_response" "CartItemApiRequestGET" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.CartItemApiResource.id
  http_method = aws_api_gateway_method.CartItemApiRequestGET.http_method
  status_code = aws_api_gateway_method_response.CartItemApiRequestGET.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'https://${aws_cloudfront_distribution.CloudFrontDistribution.domain_name}'"
  }

}

resource "aws_api_gateway_method_response" "CartItemApiRequestGET" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.CartItemApiResource.id
  http_method = aws_api_gateway_method.CartItemApiRequestGET.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = false
  }
}
#############################################

#############################################


resource "aws_api_gateway_method" "CartItemApiRequestOPTIONS" {
  rest_api_id   = aws_api_gateway_rest_api.AppApi.id
  resource_id   = aws_api_gateway_resource.CartItemApiResource.id
  authorization = "NONE"
  http_method   = "OPTIONS"

  # integration = {
  #   type = "MOCK"

  #   integration_responses = {
  #     status_code = "200"

  #     response_parameters = {
  #       "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
  #       "method.response.header.Access-Control-Allow-Methods" = "'''GET,POST,PUT,DELETE,OPTIONS,HEAD,PATCH'''"
  #       "method.response.header.Access-Control-Allow-Origin"  = "'https://${aws_cloudfront_distribution.CloudFrontDistribution.domain_name}'"
  #     }

  #     response_templates = {
  #       "application/json" = ""
  #     }
  #   }

  #   passthrough_behavior = "WHEN_NO_MATCH"

  #   request_templates = {
  #     "application/json" = "{\"statusCode\": 200}"
  #   }
  # }

  # method_responses = {
  #   status_code = "200"

  #   response_models = {
  #     "application/json" = "Empty"
  #   }

  #   response_parameters = {
  #     "method.response.header.Access-Control-Allow-Headers" = true
  #     "method.response.header.Access-Control-Allow-Methods" = true
  #     "method.response.header.Access-Control-Allow-Origin"  = true
  #   }
  # }
}

resource "aws_api_gateway_integration" "CartItemApiRequestOPTIONS" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.CartItemApiResource.id
  http_method = aws_api_gateway_method.CartItemApiRequestOPTIONS.http_method
  type        = "MOCK"

  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"

  }
}

resource "aws_api_gateway_integration_response" "CartItemApiRequestOPTIONS" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.CartItemApiResource.id
  http_method = aws_api_gateway_method.CartItemApiRequestOPTIONS.http_method
  status_code = aws_api_gateway_method_response.CartItemApiRequestOPTIONS.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'https://${aws_cloudfront_distribution.CloudFrontDistribution.domain_name}'"
  }

  response_templates = {
    "application/json" = ""
  }

}

resource "aws_api_gateway_method_response" "CartItemApiRequestOPTIONS" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.CartItemApiResource.id
  http_method = aws_api_gateway_method.CartItemApiRequestOPTIONS.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = false
    "method.response.header.Access-Control-Allow-Methods" = false
    "method.response.header.Access-Control-Allow-Origin"  = false
  }
}


resource "aws_api_gateway_resource" "CartApiResource" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  parent_id   = aws_api_gateway_rest_api.AppApi.root_resource_id
  path_part   = "cart"
}


resource "aws_api_gateway_resource" "CartItemApiResource" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  parent_id   = aws_api_gateway_resource.CartApiResource.id
  path_part   = "{bookId}"
}

###################### Search API ######################


resource "aws_api_gateway_method" "SearchApiRequestGET" {
  depends_on    = [aws_lambda_function.FunctionSearch]
  authorization = "AWS_IAM"
  http_method   = "GET"
  rest_api_id   = aws_api_gateway_rest_api.AppApi.id
  resource_id   = aws_api_gateway_resource.SearchApiResource.id

  # integration = {
  #   type                    = "AWS_PROXY"
  #   integration_http_method = "POST"
  #   uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.FunctionSearch.arn}/invocations"

  #   integration_responses = {
  #     status_code = 200
  #   }
  # }

  # request_parameters = {
  #   "method.request.querystring.q" = false
  # }

  # method_responses = {
  #   status_code = 200
  #   response_models = {
  #     "application/json" = "Empty"
  #   }
  # }
}

resource "aws_api_gateway_integration" "SearchApiRequestGET" {
  rest_api_id             = aws_api_gateway_rest_api.AppApi.id
  resource_id             = aws_api_gateway_resource.SearchApiResource.id
  http_method             = aws_api_gateway_method.SearchApiRequestGET.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.FunctionSearch.invoke_arn

  # request_parameters = {
  #   "method.request.querystring.q" = false
  # }
}

resource "aws_api_gateway_integration_response" "SearchApiRequestGET" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.SearchApiResource.id
  http_method = aws_api_gateway_method.SearchApiRequestGET.http_method
  status_code = aws_api_gateway_method_response.SearchApiRequestGET.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'https://${aws_cloudfront_distribution.CloudFrontDistribution.domain_name}'"
  }

}

resource "aws_api_gateway_method_response" "SearchApiRequestGET" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.SearchApiResource.id
  http_method = aws_api_gateway_method.SearchApiRequestGET.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = false
  }
}



resource "aws_api_gateway_method" "SearchApiRequestOPTIONS" {
  rest_api_id   = aws_api_gateway_rest_api.AppApi.id
  resource_id   = aws_api_gateway_resource.SearchApiResource.id
  authorization = "NONE"
  http_method   = "OPTIONS"

  # integration = {
  #   type = "MOCK"

  #   integration_responses = {
  #     status_code = "200"

  #     response_parameters = {
  #       "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
  #       "method.response.header.Access-Control-Allow-Methods" = "'''GET,POST,PUT,DELETE,OPTIONS,HEAD,PATCH'''"
  #       "method.response.header.Access-Control-Allow-Origin"  = "'https://${aws_cloudfront_distribution.CloudFrontDistribution.domain_name}'"
  #     }

  #     response_templates = {
  #       "application/json" = ""
  #     }
  #   }

  #   passthrough_behavior = "WHEN_NO_MATCH"

  #   request_templates = {
  #     "application/json" = "{\"statusCode\": 200}"
  #   }
  # }

  # method_responses = {
  #   status_code = "200"

  #   response_models = {
  #     "application/json" = "Empty"
  #   }

  #   response_parameters = {
  #     "method.response.header.Access-Control-Allow-Headers" = true
  #     "method.response.header.Access-Control-Allow-Methods" = true
  #     "method.response.header.Access-Control-Allow-Origin"  = true
  #   }
  # }

}

resource "aws_api_gateway_integration" "SearchApiRequestOPTIONS" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.SearchApiResource.id
  http_method = aws_api_gateway_method.SearchApiRequestOPTIONS.http_method
  type        = "MOCK"

  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"

  }
}

resource "aws_api_gateway_integration_response" "SearchApiRequestOPTIONS" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.SearchApiResource.id
  http_method = aws_api_gateway_method.SearchApiRequestOPTIONS.http_method
  status_code = aws_api_gateway_method_response.SearchApiRequestOPTIONS.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'https://${aws_cloudfront_distribution.CloudFrontDistribution.domain_name}'"
  }

  response_templates = {
    "application/json" = ""
  }

}

resource "aws_api_gateway_method_response" "SearchApiRequestOPTIONS" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.SearchApiResource.id
  http_method = aws_api_gateway_method.SearchApiRequestOPTIONS.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = false
    "method.response.header.Access-Control-Allow-Methods" = false
    "method.response.header.Access-Control-Allow-Origin"  = false
  }
}

resource "aws_api_gateway_resource" "SearchApiResource" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  parent_id   = aws_api_gateway_rest_api.AppApi.root_resource_id
  path_part   = "search"
}


####################### Bestseller API ##########################

resource "aws_api_gateway_method" "BestsellersApiRequestGET" {
  depends_on    = [aws_lambda_function.FunctionGetBestSellers]
  authorization = "AWS_IAM"
  http_method   = "GET"
  rest_api_id   = aws_api_gateway_rest_api.AppApi.id
  resource_id   = aws_api_gateway_resource.BestsellersApiResource.id

  # integration = {
  #   type                    = "AWS_PROXY"
  #   integration_http_method = "POST"
  #   uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.FunctionGetBestSellers.arn}/invocations"

  #   integration_responses = {
  #     status_code = 200
  #   }
  # }

  # method_responses = {
  #   status_code = 200
  #   response_models = {
  #     "application/json" = "Empty"
  #   }
  # }
}

resource "aws_api_gateway_integration" "BestsellersApiRequestGET" {
  rest_api_id             = aws_api_gateway_rest_api.AppApi.id
  resource_id             = aws_api_gateway_resource.BestsellersApiResource.id
  http_method             = aws_api_gateway_method.BestsellersApiRequestGET.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.FunctionGetBestSellers.invoke_arn
}

resource "aws_api_gateway_integration_response" "BestsellersApiRequestGET" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.BestsellersApiResource.id
  http_method = aws_api_gateway_method.BestsellersApiRequestGET.http_method
  status_code = aws_api_gateway_method_response.BestsellersApiRequestGET.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'https://${aws_cloudfront_distribution.CloudFrontDistribution.domain_name}'"

  }

}

resource "aws_api_gateway_method_response" "BestsellersApiRequestGET" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.BestsellersApiResource.id
  http_method = aws_api_gateway_method.BestsellersApiRequestGET.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = false
  }
}



resource "aws_api_gateway_method" "BestsellersApiRequestOPTIONS" {
  rest_api_id   = aws_api_gateway_rest_api.AppApi.id
  resource_id   = aws_api_gateway_resource.BestsellersApiResource.id
  authorization = "NONE"
  http_method   = "OPTIONS"

  # integration = {
  #   type = "MOCK"

  #   integration_responses = {
  #     status_code = "200"

  #     response_parameters = {
  #       "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
  #       "method.response.header.Access-Control-Allow-Methods" = "'''GET,POST,PUT,DELETE,OPTIONS,HEAD,PATCH'''"
  #       "method.response.header.Access-Control-Allow-Origin"  = "'https://${aws_cloudfront_distribution.CloudFrontDistribution.domain_name}'"
  #     }

  #     response_templates = {
  #       "application/json" = ""
  #     }
  #   }

  #   passthrough_behavior = "WHEN_NO_MATCH"

  #   request_templates = {
  #     "application/json" = "{\"statusCode\": 200}"
  #   }
  # }

  # method_responses = {
  #   status_code = "200"

  #   response_models = {
  #     "application/json" = "Empty"
  #   }

  #   response_parameters = {
  #     "method.response.header.Access-Control-Allow-Headers" = true
  #     "method.response.header.Access-Control-Allow-Methods" = true
  #     "method.response.header.Access-Control-Allow-Origin"  = true
  #   }
  # }
}

resource "aws_api_gateway_integration" "BestsellersApiRequestOPTIONS" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.BestsellersApiResource.id
  http_method = aws_api_gateway_method.BestsellersApiRequestOPTIONS.http_method
  type        = "MOCK"

  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"

  }
}

resource "aws_api_gateway_integration_response" "BestsellersApiRequestOPTIONS" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.BestsellersApiResource.id
  http_method = aws_api_gateway_method.BestsellersApiRequestOPTIONS.http_method
  status_code = aws_api_gateway_method_response.BestsellersApiRequestOPTIONS.status_code


  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'https://${aws_cloudfront_distribution.CloudFrontDistribution.domain_name}'"
  }

  response_templates = {
    "application/json" = ""
  }

}

resource "aws_api_gateway_method_response" "BestsellersApiRequestOPTIONS" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  resource_id = aws_api_gateway_resource.BestsellersApiResource.id
  http_method = aws_api_gateway_method.BestsellersApiRequestOPTIONS.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = false
    "method.response.header.Access-Control-Allow-Methods" = false
    "method.response.header.Access-Control-Allow-Origin"  = false
  }
}


resource "aws_api_gateway_resource" "BestsellersApiResource" {
  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  parent_id   = aws_api_gateway_rest_api.AppApi.root_resource_id
  path_part   = "bestsellers"
}


#################### ApiAuthorizer ###################


resource "aws_api_gateway_authorizer" "ApiAuthorizer" {
  rest_api_id                      = aws_api_gateway_rest_api.AppApi.id
  name                             = "CognitoDefaultUserPoolAuthorizer"
  type                             = "COGNITO_USER_POOLS"
  provider_arns                    = [aws_cognito_user_pool.CognitoUserPool.arn]
  identity_source                  = "method.request.header.Authorization"
  authorizer_result_ttl_in_seconds = 300
}


######################## APIDeployment ##########################


resource "aws_api_gateway_deployment" "APIDeployment" {
  depends_on = [
    aws_api_gateway_method.BooksApiRequestGET,
    aws_api_gateway_method.BooksApiRequestOPTIONS,
    aws_api_gateway_method.BookItemApiRequestGET,
    aws_api_gateway_method.BookItemApiRequestOPTIONS,
    aws_api_gateway_method.OrdersApiRequestGET,
    aws_api_gateway_method.OrdersApiRequestPOST,
    aws_api_gateway_method.OrdersApiRequestOPTIONS,
    aws_api_gateway_method.CartApiRequestGET,
    aws_api_gateway_method.CartApiRequestPUT,
    aws_api_gateway_method.CartApiRequestPOST,
    aws_api_gateway_method.CartApiRequestDELETE,
    aws_api_gateway_method.CartApiRequestOPTIONS,
    aws_api_gateway_method.CartItemApiRequestGET,
    aws_api_gateway_method.CartItemApiRequestOPTIONS,
    aws_api_gateway_method.RecomendationsApiRequestGET,
    aws_api_gateway_method.RecomendationsApiRequestOPTIONS,
    aws_api_gateway_method.RecomendationsByBookApiRequestGET,
    aws_api_gateway_method.RecomendationsByBookApiRequestOPTIONS,
    aws_api_gateway_method.SearchApiRequestGET,
    aws_api_gateway_method.SearchApiRequestOPTIONS,
    aws_api_gateway_method.BestsellersApiRequestGET,
    aws_api_gateway_method.BestsellersApiRequestOPTIONS,
  ]

  rest_api_id = aws_api_gateway_rest_api.AppApi.id
  stage_name  = "prod"
  description = "Prod deployment for API"

}
