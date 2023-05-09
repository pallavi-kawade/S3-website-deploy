# # Creating S3 Bucket to store Objects
# resource "aws_s3_bucket" "create_bucket" {
#   bucket = var.bucket_name
#   force_destroy = true
#   tags = {
#     Name = format("%v-%v-s3Bucket", var.project, var.environment)
#   }
# }
# resource "aws_s3_bucket_acl" "bucket_acl" {
#   bucket = aws_s3_bucket.create_bucket.id
#   acl    = "private"
# }

# # Attaching Policy to S3 Bucket
# resource "aws_s3_bucket_policy" "bucket_policy" {
#   bucket = aws_s3_bucket.create_bucket.id
#   policy = data.aws_iam_policy_document.bucket_policy_document.json
# }

# resource "aws_s3_object" "object" {

#   bucket = aws_s3_bucket.create_bucket.id

#   key = "about.html"

#   source = "./about.html"

#   content_type = "text/html"

#   depends_on = [
#     aws_s3_bucket.create_bucket
#   ]

# }

# S3 bucket for website
resource "aws_s3_bucket" "www_bucket" {
  bucket = "www.${var.bucket_name}"
  #acl    = "public-read"
  #policy = templatefile("templates/s3-policy.json", { bucket = "www.${var.bucket_name}" })
}
resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = "www.${var.bucket_name}"
  policy = templatefile("templates/s3-policy.json", { bucket = "www.${var.bucket_name}" })
}
  resource "aws_s3_bucket_cors_configuration" "CorsEx" {
     bucket = "www.${var.bucket_name}"
    cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["https://www.${var.domain_name}"]
    max_age_seconds = 3000
  }
  }
 resource "aws_s3_bucket_acl" "ACLEx" {
   bucket = "www.${var.bucket_name}"
  acl    = "public-read"
}

resource "aws_s3_bucket_versioning" "versioning_example" {
   bucket = "www.${var.bucket_name}"
  versioning_configuration {
    status = "Enabled"
  }
}

  resource "aws_s3_bucket_website_configuration" "WebConfig" {
  bucket = "www.${var.bucket_name}"
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  routing_rule {
    condition {
      key_prefix_equals = "docs/"
    }
    redirect {
      replace_key_prefix_with = "documents/"
    }
  }
}
 