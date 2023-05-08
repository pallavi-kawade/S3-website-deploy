
#Create a Amazon S3 website & deploy it on AWS through pipeline

## Overview

This template will serve the content from S3 which would accessible only with CloudFront URL. CloudFront delivers content through a worldwide network with very low latency and high performance.
This terraform code will create the clodfront distribution, s3 bucket & will attach the origin access identity to s3 bucket.

## Requirements

| Name      | Version |
| --------- | ------- |
| terraform | ~> 1.0  |

## files
about.html file is used for testing purpose.

## Providers

| Name | Version |
| ---- | ------- |
| aws  | ~> 3.0  |

## Inputs

| Name                       | Description                                                                               | Type     | Default      | Required |
| -------------------------- | ----------------------------------------------------------------------------------------- | -------- | ------------ | :------: |
| aws_region                     | Name of the aws region region                                                                                | `string` | n/a         |   yes    |
| project                    | Project or organisation name                                                           | `string` | n/a  |    yes    |
| environment                | Application environment name (dev/prod/qa)                                                | `string` |  n/a     |   yes    |
| username             | Name of the user                                           | `string` |   n/a        |   yes    |
| bucket_name           | Name of the S3 bucket                                                             | `string` | ""    |   yes    |
| origin_id          | Origin id for cloudfront distribution                                                             | `string` |  `S3-Origin`         |   yes    |
| oai_comment           | Comment for the origin access identity                                                   | `string` | `OAI for S3 bucket for get object only`          |   no    |
| ttl          | Time to Leave for caches in Edge Location                                                | `number` |  `3600`   |   yes  |
| acm_certificate_arn | Existing ACM Certificate ARN | `string` | "" | no |
| viewer_minimum_protocol_version | The minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections | `string` | `TLSv1` | no |





## Output

|   Name             |      Description                  |   Type                       |
| -------------------| --------------------------------- |------------------------------|
| cloudfront_domain  | Distribution domain name provided by cloudfront          | `string` |
| bucket_name        | S3 bucket name                    | `string`             |
| cf_arn             | Cloudfront Arn                    | `string`             |
| Oai_id             | Origin Access Identity Id         | `string`             |


## Development

### Prerequisites

- [terraform](https://learn.hashicorp.com/terraform/getting-started/install#installing-terraform)
- [terraform-docs](https://github.com/segmentio/terraform-docs)


## ###  Prerequisites for terratest and HTML report generation

1. Export backend variables


    export bucket=<bucket_name>

    export key=<key_name>

    export region=<bucket_region>