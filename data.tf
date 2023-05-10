# # S3 Bucket Policy for Object Access Identity
#  data "aws_iam_policy_document" "bucket_policy_document" {
#    statement {
#      actions = ["s3:GetObject"]
    


#      resources = [
#        aws_s3_bucket.create_bucket.arn,
#        "${aws_s3_bucket.create_bucket.arn}/*"
#      ]

     

#      principals {
#        type        = "AWS"
#        identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
#      }
#    }
#  }

data "aws_iam_policy_document" "bucket_policy_document" {
  statement {
    actions = ["s3:GetObject"]

    resources = [
      aws_s3_bucket.create_bucket.arn,
      "${aws_s3_bucket.create_bucket.arn}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }

  statement {
    sid     = "Allow-Public-Access-To-Bucket"
    actions = ["s3:GetObject"]

    resources = [
      aws_s3_bucket.create_bucket.arn,
      "${aws_s3_bucket.create_bucket.arn}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.create_bucket.id
  policy = data.aws_iam_policy_document.bucket_policy_document.json
}
