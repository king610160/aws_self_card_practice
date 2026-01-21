# 產生 dynamoDB, 然後還有對應的 table 名稱
resource "aws_dynamodb_table" "user_card_table" {
  name           = "UserCards"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  # 權限提示：這裡不需要定義誰能讀取，
  # 權限是在 Lambda 的 IAM Role 那邊定義「我有權讀這張表」。
}