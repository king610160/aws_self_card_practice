# 存放圖片
resource "aws_s3_bucket" "card_assets" {
  bucket = "my-card-project-assets-${random_id.id.hex}"
}

# 隨機 ID
resource "random_id" "id" {
  byte_length = 4
}

# 權限控管：封鎖所有公開存取 (這是目前 AWS 的最佳實踐)
resource "aws_s3_bucket_public_access_block" "card_assets_block" {
  bucket                  = aws_s3_bucket.card_assets.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 要讓 CloudFront 讀取，會在這裡加入「aws_s3_bucket_policy」
resource "aws_s3_bucket_policy" "allow_access_from_cloudfront" {
  bucket = aws_s3_bucket.card_assets.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipalReadOnly"
        Effect    = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.card_assets.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.s3_distribution.arn
          }
        }
      }
    ]
  })
}