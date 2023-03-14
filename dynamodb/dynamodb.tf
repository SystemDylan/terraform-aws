resource "aws_dynamodb_table" "my_table" {
  name           = "MyTable"
  billing_mode   = "PROVISIONED"
  read_capacity  = 50
  write_capacity = 50
  hash_key       = "Id"
  range_key      = "Timestamp"

  attribute {
    name = "Id"
    type = "S"
  }

  attribute {
    name = "Timestamp"
    type = "N"
  }
}

resource "aws_dynamodb_table" "my_table2" {
  name           = "MyTable2"
  billing_mode   = "PROVISIONED"
  read_capacity  = 15
  write_capacity = 15
  hash_key       = "Id"

  attribute {
    name = "Id"
    type = "S"
  }
}
