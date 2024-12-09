output "cloudfront_urls" {
  value = { for k, dist in aws_cloudfront_distribution.frontend_app_distribution : 
            k => dist.domain_name 
          }
}
