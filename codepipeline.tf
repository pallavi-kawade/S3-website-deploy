
# Create IAM role for pipeline
resource "aws_iam_role" "pipeline_role" {
  name = "example-pipeline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      }
    ]
  })
}

# Attach permissions policy to IAM role for pipeline
resource "aws_iam_role_policy_attachment" "pipeline_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodePipelineFullAccess"
  role       = aws_iam_role.pipeline_role.name
}

# Create CodePipeline artifact bucket
resource "aws_s3_bucket" "pipeline_artifact_bucket" {
  bucket_prefix = "example-pipeline-artifacts"
  acl           = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name = "Example Pipeline Artifact Bucket"
  }
}

# Create S3 bucket for hosting website
resource "aws_s3_bucket" "example_bucket" {
  bucket = "aws-bucket-static-website"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  logging {
    target_bucket = "aws-logs-bucket"
    target_prefix = "aws-bucket-static-website"
  }

  tags = {
    Name = "Example Website Bucket"
  }
}

# Create CodeBuild project for building website
resource "aws_codebuild_project" "example_build" {
  name        = "example-build"
  description = "Build static website"
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:4.0"
    type         = "LINUX_CONTAINER"
  }
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "ZIP"
    name = "website-build"
  }

  source {
    type            = "S3"
    location        = aws_s3_bucket.pipeline_artifact_bucket.bucket
    buildspec       = "buildspec.yml"
    git_clone_depth = 1
  }

  tags = {
    Name = "Example Build Project"
  }
}

# Create CodePipeline
resource "aws_codepipeline" "example_pipeline" {
  name     = "example-pipeline"
  role_arn = aws_iam_role.pipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.pipeline_artifact_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name            = "Source"
      category        = "Source"
      owner           = "ThirdParty"
      provider        = "GitHub"
      version         = "1"
      output_artifacts = ["source_output"]

      configuration {
        Owner      = "pallavi-kawade"
        Repo       = "S3-website-deploy"
        Branch     = "main"
        OAuthToken = var.github_token
      }
    }
  }
}
#   stage {
#     name = "Build"

#     action {
#       name            = "Build"
#       category        = "Build"
#       owner           = "AWS"
#       provider        = "CodeBuild"
#       version         = "1"
#       input_artifacts = ["source_output"]
#     }
#     }

# Define IAM policy for CodeBuild role
resource "aws_iam_policy" "codebuild" {
  name = "my-website-codebuild-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:Get*",
          "s3:PutObject"
        ]
        Resource = [
          "arn:aws:s3:::aws-bucket-static-website/*"
        ]
      }
    ]
  })
}

# # Attach IAM policy to CodeBuild role
# resource "aws_iam_role_policy_attachment" "codebuild" {
#   policy_arn = aws_iam_policy.codebuild.arn
#   role       = aws_iam_role.codebuild.name
# }

# # Define CodePipeline resource
# resource "aws_codepipeline" "website" {
#   name = "my-website-pipeline"
#   role_arn = aws_iam_role.codepipeline.arn

#   artifact_store {
#     location = "my-website-pipeline-artifacts"
#     type     = "S3"
#   }
# }

  stage {
    name = "Source"

    action {
      name            = "Source"
      category        = "Source"
      owner           = "ThirdParty"
      provider        = "GitHub"
      version         = "1"
      output_artifacts = ["source"]

      configuration {
        Owner = "pallavi-kawade"
        Repo = "S3-website-deploy"
        Branch = "main"
        OAuthToken = var.github_oauth_token
      }
    }
  }

  stage {
    name = "Build"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts  = ["source"]
      output_artifacts = ["build"]

      configuration {
        ProjectName = aws_codebuild_project.build.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      version         = "1"
      input_artifacts = ["build"]

      configuration {
        BucketName = "aws-bucket-static-website"
      }
    }
  }
