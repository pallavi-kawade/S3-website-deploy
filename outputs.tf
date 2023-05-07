# Output for CloudFront Domain Name
output "cloudfront_domain" {
  value = aws_cloudfront_distribution.cloudFront_distribution.domain_name
}


output "bucket_name" {
  value = aws_s3_bucket.create_bucket.bucket
}

output "cf_arn" {
  value = aws_cloudfront_distribution.cloudFront_distribution.arn
}

output "Oai_id" {
  value = aws_cloudfront_origin_access_identity.origin_access_identity.id
}



