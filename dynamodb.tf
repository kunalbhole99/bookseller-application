resource "aws_dynamodb_table" "DynamoDBTable" {
  attribute {
    name = "category"
    type = "S"
  }
  attribute {
    name = "id"
    type = "S"
  }
  name           = "mybookstore-Books"
  hash_key       = "id"
  read_capacity  = 1
  write_capacity = 1
  global_secondary_index {
    name            = "category-index"
    hash_key        = "category"
    projection_type = "ALL"
    read_capacity   = 1
    write_capacity  = 1
  }
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
}

resource "aws_dynamodb_table" "DynamoDBTable2" {
  attribute {
    name = "bookId"
    type = "S"
  }
  attribute {
    name = "customerId"
    type = "S"
  }
  name           = "mybookstore-Cart"
  hash_key       = "customerId"
  range_key      = "bookId"
  read_capacity  = 1
  write_capacity = 1
}

resource "aws_dynamodb_table" "DynamoDBTable3" {
  attribute {
    name = "customerId"
    type = "S"
  }
  attribute {
    name = "orderId"
    type = "S"
  }
  name             = "mybookstore-Orders"
  hash_key         = "customerId"
  range_key        = "orderId"
  read_capacity    = 1
  write_capacity   = 1
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
}
