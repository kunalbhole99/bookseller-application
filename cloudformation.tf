resource "aws_cloudformation_stack" "books_uploader" {
  name = "BooksUploader"

  template_body = jsonencode({
    "Resources" : {
      "BooksUploader" : {
        "Type" : "Custom::CustomResource",
        "Properties" : {
          "ServiceToken" : "${aws_lambda_function.FunctionUploadBooks.arn}",
          "ParameterOne" : "Parameter to pass into Custom Lambda Function"
        }
      }
    }
  })

  depends_on = [
    aws_lambda_function.FunctionUploadBooks,
    aws_elasticsearch_domain.OpenSearchServiceDomain,
    aws_lambda_function.UpdateSearchCluster
  ]
}


########################## ES Role Creator Lambda function Trigger using this cloudformation #################################

resource "aws_cloudformation_stack" "es_role_creator" {
  name = "ESRoleCreator"

  template_body = jsonencode({
    "Resources" : {
      "ESRoleCreator" : {
        "Type" : "Custom::CustomResource",
        "Properties" : {
          "ServiceToken" : "${aws_lambda_function.CreateOSRoleFunction.arn}",
          "ParameterOne" : "Parameter to pass into Custom Lambda Function"
        }
      }
    }

  })
  depends_on = [
    aws_lambda_function.CreateOSRoleFunction
  ]
}

################## repoupdate Lambda function Trigger using this cloudformation


resource "aws_cloudformation_stack" "repository_updater" {
  name = "RepositoryUpdater"

  template_body = jsonencode({
    "Resources" : {
      "RepositoryUpdater" : {
        "Type" : "Custom::CustomResource",
        "Properties" : {
          "ServiceToken" : "${aws_lambda_function.UpdateConfigFunction.arn}"
          "ParameterOne" : "Parameter to pass into Custom Lambda Function"
        }
      }
    }
  })

  depends_on = [
    aws_lambda_function.UpdateConfigFunction,
    null_resource.git_push
  ]
}


######################### Stack to trigger lambda function and it will upload the books into neptune db 


resource "aws_cloudformation_stack" "bookstoreNeptuneLoader" {
  name = "bookstoreNeptuneLoader"

  template_body = jsonencode({
    "Resources" : {
      "bookstoreNeptuneLoader" : {
        "Type" : "Custom::CustomResource",
        "Properties" : {
          "ServiceToken" : "${aws_lambda_function.bookstoreNeptuneLoaderLambda.arn}"
          "ParameterOne" : "CUSTOM RESOURCE TO INITIATE NEPTUNE BULK LOAD PROCESS"
        }
      }
    }
  })

  depends_on = [
    aws_iam_role_policy.IAMPolicy5,
    aws_iam_role_policy.IAMPolicy6,
    aws_iam_role_policy.IAMPolicy10,
    aws_iam_role_policy.IAMPolicy4,
    aws_iam_role.mybookstore-bookstoreNeptuneLoaderLambdaRole,
    aws_lambda_function.bookstoreNeptuneLoaderLambda,
    aws_iam_role.mybookstore-bookstoreNeptuneLoaderS3ReadRole,
    aws_route_table_association.EC2SubnetRouteTableAssociation,
    aws_route_table_association.EC2SubnetRouteTableAssociation2,
    aws_vpc_endpoint.EC2VPCEndpoint,
    aws_neptune_cluster.NeptuneDBCluster
  ]
}


# resource "aws_cloudformation_stack" "bookstoreNeptuneIAMattach" {
#   name = "bookstoreNeptuneIAMattach"

#   template_body = jsonencode({
#     "Resources" : {
#       "bookstoreNeptuneIAMattach" : {
#         "Type" : "Custom::CustomResource",
#         "Properties" : {
#           "ServiceToken" : "${aws_lambda_function.bookstoreNeptuneIAMAttachLambda.arn}"
#           "ParameterOne" : "CUSTOM RESOURCE TO INITIATE NEPTUNE BULK LOAD PROCESS"
#         }
#       }
#     }
#   })

#   depends_on = [
#     aws_neptune_cluster.NeptuneDBCluster,
#     aws_iam_role.mybookstore-bookstoreNeptuneLoaderS3ReadRole,
#     aws_lambda_function.bookstoreNeptuneIAMAttachLambda
#   ]
# }
