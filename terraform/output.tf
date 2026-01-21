# 定義輸出
output "dynamodb_table_name" {
  value = aws_dynamodb_table.user_card_table.name
}

output "s3_bucket_id" {
  value = aws_s3_bucket.card_assets.id
}

# 輸出 CloudFront 的分配域名
output "cloudfront_domain_name" {
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
  description = "這是你的 CDN 網址，之後圖片就要用這個開頭"
}

# 輸出 CloudFront 的 ID (方便以後去後台查)
output "cloudfront_id" {
  value = aws_cloudfront_distribution.s3_distribution.id
}

# 輸出 api-gateway URL
output "api_url" {
  value = aws_apigatewayv2_api.lambda_api.api_endpoint
}