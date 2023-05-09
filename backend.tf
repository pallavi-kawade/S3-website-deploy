terraform {
  backend "s3" {
    key = "terraform.tfstate"
    bucket = "tf-file-store-bucket"
    region = "us-east-1"

  }
}

