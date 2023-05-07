# Provider for Terraform
provider "aws" {
  region  = var.aws_region
  default_tags {
    tags = {
      Environment = var.environment
      ManagedBy   = "Terraform"
      CreatedBy   = var.username
      Project     = var.project
    }
  }
}
