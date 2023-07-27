#
# data "aws_cognito_identity_provider" "CognitoIdentityProvider" {
#   user_pool_id = aws_cognito_user_pool.CognitoUserPool.id
#   provider_name = "cognito-idp.${var.region}.amazonaws.com/${aws_cognito_user_pool.CognitoUserPool.id}"
# }

# Create cognito identity pool :

resource "aws_cognito_identity_pool" "CognitoIdentityPool" {
  identity_pool_name               = "mybookstoreIdentity"
  allow_unauthenticated_identities = true
  cognito_identity_providers {
    client_id = aws_cognito_user_pool_client.CognitoUserPoolClient.id
    #client_id = data.aws_cognito_identity_provider.CognitoIdentityProvider.client_id
    provider_name           = "cognito-idp.${var.region}.amazonaws.com/${aws_cognito_user_pool.CognitoUserPool.id}"
    server_side_token_check = false
  }
}

# Create cognito identity pool roles attachment:

resource "aws_cognito_identity_pool_roles_attachment" "CognitoIdentityPoolRoleAttachment" {
  identity_pool_id = aws_cognito_identity_pool.CognitoIdentityPool.id
  roles = {
    authenticated   = aws_iam_role.mybookstore-CognitoAuthorizedRole.arn
    unauthenticated = aws_iam_role.mybookstore-CognitoUnAuthorizedRole.arn
  }
}

# Create cognito user pool:

resource "aws_cognito_user_pool" "CognitoUserPool" {
  lifecycle {
    ignore_changes = [
      schema,          # Ignore any changes to the schema block
      password_policy, # Ignore any changes to the password_policy block
      lambda_config,
    ]
  }
  name = "bookstore"
  account_recovery_setting {
    recovery_mechanism {
      priority = 1
      name     = "verified_email"
    }
  }
  password_policy {
    minimum_length    = 8
    require_lowercase = false
    require_numbers   = false
    require_symbols   = false
    require_uppercase = false
  }
  lambda_config {

  }
  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = false
    name                     = "sub"
    string_attribute_constraints {
      #max_length = "2048"
      #min_length = "1"
    }
    required = true
  }
  # schema {
  #     attribute_data_type = "String"
  #     developer_only_attribute = false
  #     mutable = true
  #     name = "name"
  #     string_attribute_constraints {
  #         #max_length = "20"
  #         #min_length = "0"
  #     }
  #     required = false
  # }
  # schema {
  #     attribute_data_type = "String"
  #     developer_only_attribute = false
  #     mutable = true
  #     name = "given_name"
  #     string_attribute_constraints {
  #         #max_length = "20"
  #         #min_length = "0"
  #     }
  #     required = false
  # }
  # schema {
  #     attribute_data_type = "String"
  #     developer_only_attribute = false
  #     mutable = true
  #     name = "family_name"
  #     string_attribute_constraints {
  #         #max_length = "20"
  #         #min_length = "0"
  #     }
  #     required = false
  # }
  # schema {
  #     attribute_data_type = "String"
  #     developer_only_attribute = false
  #     mutable = true
  #     name = "middle_name"
  #     string_attribute_constraints {
  #         #max_length = "20"
  #         #min_length = "0"
  #     }
  #     required = false
  # }
  # schema {
  #     attribute_data_type = "String"
  #     developer_only_attribute = false
  #     mutable = true
  #     name = "nickname"
  #     string_attribute_constraints {
  #         #max_length = "20"
  #         #min_length = "0"
  #     }
  #     required = false
  # }
  # schema {
  #     attribute_data_type = "String"
  #     developer_only_attribute = false
  #     mutable = true
  #     name = "preferred_username"
  #     string_attribute_constraints {
  #         #max_length = "20"
  #         #min_length = "0"
  #     }
  #     required = false
  # }
  # schema {
  #     attribute_data_type = "String"
  #     developer_only_attribute = false
  #     mutable = true
  #     name = "profile"
  #     string_attribute_constraints {
  #         #max_length = "20"
  #         #min_length = "0"
  #     }
  #     required = false
  # }
  # schema {
  #     attribute_data_type = "String"
  #     developer_only_attribute = false
  #     mutable = true
  #     name = "picture"
  #     string_attribute_constraints {
  #         #max_length = "20"
  #         #min_length = "0"
  #     }
  #     required = false
  # }
  # schema {
  #     attribute_data_type = "String"
  #     developer_only_attribute = false
  #     mutable = true
  #     name = "website"
  #     string_attribute_constraints {
  #         #max_length = "20"
  #         #min_length = "0"
  #     }
  #     required = false
  # }
  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = false
    name                     = "email"
    string_attribute_constraints {
      #max_length = "20"
      #min_length = "0"
    }
    required = true
  }
  # schema {
  #     attribute_data_type = "Boolean"
  #     developer_only_attribute = false
  #     mutable = true
  #     name = "email_verified"
  #     required = false
  # }
  # schema {
  #     attribute_data_type = "String"
  #     developer_only_attribute = false
  #     mutable = true
  #     name = "gender"
  #     string_attribute_constraints {
  #         #max_length = "20"
  #         #min_length = "0"
  #     }
  #     required = false
  # }
  # schema {
  #     attribute_data_type = "String"
  #     developer_only_attribute = false
  #     mutable = true
  #     name = "birthdate"
  #     string_attribute_constraints {
  #         #max_length = "10"
  #         #min_length = "10"
  #     }
  #     required = false
  # }
  # schema {
  #     attribute_data_type = "String"
  #     developer_only_attribute = false
  #     mutable = true
  #     name = "zoneinfo"
  #     string_attribute_constraints {
  #         #max_length = "20"
  #         #min_length = "0"
  #     }
  #     required = false
  # }
  # schema {
  #     attribute_data_type = "String"
  #     developer_only_attribute = false
  #     mutable = true
  #     name = "locale"
  #     string_attribute_constraints {
  #         #max_length = "20"
  #         #min_length = "0"
  #     }
  #     required = false
  # }
  # schema {
  #     attribute_data_type = "String"
  #     developer_only_attribute = false
  #     mutable = true
  #     name = "phone_number"
  #     string_attribute_constraints {
  #         #max_length = "20"
  #         #min_length = "0"
  #     }
  #     required = false
  # }
  # schema {
  #     attribute_data_type = "Boolean"
  #     developer_only_attribute = false
  #     mutable = true
  #     name = "phone_number_verified"
  #     required = false
  # }
  # schema {
  #     attribute_data_type = "String"
  #     developer_only_attribute = false
  #     mutable = true
  #     name = "address"
  #     string_attribute_constraints {
  #         #max_length = "20"
  #         #min_length = "0"
  #     }
  #     required = false
  # }
  # schema {
  #     attribute_data_type = "Number"
  #     developer_only_attribute = false
  #     mutable = true
  #     name = "updated_at"
  #     number_attribute_constraints {
  #         min_value = "0"
  #     }
  #     required = false
  # }
  auto_verified_attributes = [
    "email"
  ]
  username_attributes = [
    "email"
  ]
  email_verification_message = "Here is your verification code: {####}"
  email_verification_subject = "Your verification code"
  mfa_configuration          = "OFF"
  email_configuration {

  }
  admin_create_user_config {
    allow_admin_create_user_only = false
    invite_message_template {
      email_message = "Your username is {username} and temporary password is {####}. "
      email_subject = "Your temporary password"
      sms_message   = "Your username is {username} and temporary password is {####}."
    }
    #unused_account_validity_days = 7-----> deprecated argument
  }
  tags = {}


}



# Create cognito user pool client:

resource "aws_cognito_user_pool_client" "CognitoUserPoolClient" {
  user_pool_id           = aws_cognito_user_pool.CognitoUserPool.id
  name                   = "mybookstore-client"
  refresh_token_validity = 30
}
