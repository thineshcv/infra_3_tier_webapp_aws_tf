resource "aws_s3_bucket" "frontend_app_buckets" {
  for_each = var.apps
  bucket   = "tuu-${each.value}-bucket"
  tags = {
    project = var.project
    env     = var.env
  }
}

resource "aws_s3_bucket_website_configuration" "website_configuration" {
  for_each = aws_s3_bucket.frontend_app_buckets
  bucket   = each.value.bucket
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_policy" "frontend_app_buckets_policy" {
  for_each = aws_s3_bucket.frontend_app_buckets
  bucket   = each.value.bucket
  policy   = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${each.value.arn}/*"
      }
    ]
  })
}

resource "aws_cloudfront_distribution" "frontend_app_distribution" {
  for_each = aws_s3_bucket.frontend_app_buckets
  origin {
    domain_name = each.value.bucket_regional_domain_name
    origin_id   = each.value.bucket
  }
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = each.value.bucket
    viewer_protocol_policy = "redirect-to-https"
    
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }
  
  viewer_certificate {
    cloudfront_default_certificate = true
  }
  
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  
  tags = {
    project = var.project
    env     = var.env
  }
}