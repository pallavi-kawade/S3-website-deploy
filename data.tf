# S3 Bucket Policy for Object Access Identity
 data "aws_iam_policy_document" "bucket_policy_document" {
   statement {
     actions = ["s3:GetObject"]
    


     resources = [
       aws_s3_bucket.create_bucket.arn,
       "${aws_s3_bucket.create_bucket.arn}/*"
     ]

     statement {
    actions = ["s3:GetObject"]
    principals = {
      type = "AWS"
      identifiers = ["*"]
    }
    effect = "Allow"

resources = [
       aws_s3_bucket.create_bucket.arn,
       "${aws_s3_bucket.create_bucket.arn}/*"
     ]
     }
     
     principals {
       type        = "AWS"
       identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
     }
   }
 }

