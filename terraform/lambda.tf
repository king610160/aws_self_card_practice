# 1. 準備程式碼 ZIP 檔 (Terraform 可以幫你打包)
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "../build" # 你的 Python 程式碼資料夾
  output_path = "lambda_function.zip"
}

# 2. 建立 Lambda 執行的身份 (IAM Role)
resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

# 3. 賦予 Lambda 讀取 DynamoDB 的權限
resource "aws_iam_role_policy" "lambda_db_policy" {
  role = aws_iam_role.lambda_exec.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["dynamodb:GetItem", "dynamodb:Query"]
        Effect   = "Allow"
        Resource = aws_dynamodb_table.user_card_table.arn
      },
      {
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# 4. 建立 Lambda 函數
resource "aws_lambda_function" "api_handler" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "CardProjectAPI"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "main.handler" # 檔案名.變數名
  runtime          = "python3.12"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.user_card_table.name
    }
  }
}