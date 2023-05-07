# Creating CloudFront Distribution for Origin S3
resource "aws_cloudfront_distribution" "cloudFront_distribution" {
  origin {
    domain_name = aws_s3_bucket.create_bucket.bucket_regional_domain_name
    origin_id   = var.origin_id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled = true

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = var.ttl
    max_ttl                = 86400
  }


  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
    
  }


  viewer_certificate {
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = var.viewer_minimum_protocol_version
    cloudfront_default_certificate = var.acm_certificate_arn == "" ? true : false
  }
  

}

# Creating Origin Access Identity in CloudFornt
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = var.oai_comment
}

