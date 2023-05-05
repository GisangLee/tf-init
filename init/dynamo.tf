# # DynamoDB for terraform state lock
# resource "aws_dynamodb_table" "tf-state-lock-dynamo" {
#   name         = "${var.PROJECT_NAME}-${var.ENV}-tf-state-lock-dynamo"
#   hash_key     = "LockID"
#   billing_mode = "PAY_PER_REQUEST"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }