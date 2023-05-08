
variable "project" {
  description = "Project or organisation name"
  type        = string
}

variable "environment" {
  description = "Application environment name (dev/prod/qa)"
  type        = string
}

variable "username" {
  description = "Name of the user"
  type        = string
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}


variable "aws_region" {
  description = "Name of the aws region"
  type        = string
}

variable "origin_id" {
  description = "Origin id for cloudfront distribution"
  type        = string
  default     = "S3-Origin"
}

variable "oai_comment" {
  description = "Comment for the origin access identity"
  type        = string
  default     = "OAI for S3 bucket for get object only"
}

variable "ttl" {
  description = "Time to Leave for caches in Edge Location"
  type        = number
  default     = 3600
}

variable "acm_certificate_arn" {
  type        = string
  description = "Existing ACM Certificate ARN"
  default     = ""
}

variable "viewer_minimum_protocol_version" {
  type        = string
  description = "The minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections"
  default     = "TLSv1"
}