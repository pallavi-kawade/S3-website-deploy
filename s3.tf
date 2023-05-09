# Creating S3 Bucket to store Objects
resource "aws_s3_bucket" "create_bucket" {
  bucket = var.bucket_name
  force_destroy = true
  tags = {
    Name = format("%v-%v-s3Bucket", var.project, var.environment)
  }
}
resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.create_bucket.id
  acl    = "public-read"
}

# Attaching Policy to S3 Bucket
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.create_bucket.id
  policy = data.aws_iam_policy_document.bucket_policy_document.json
}

resource "aws_s3_object" "object" {

  bucket = aws_s3_bucket.create_bucket.id

  key = "about.html"

  source = "./about.html"

  content_type = "text/html"

  depends_on = [
    aws_s3_bucket.create_bucket
  ]

}

