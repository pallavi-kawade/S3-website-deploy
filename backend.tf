terraform {
  backend "s3" {
    key = "terraform.tfstate"
    bucket = "tf-file-store-bucket"

  }
}


# terraform {
#   backend "s3" {
#     bucket = "my-terraform-state-bucket"
#     key    = "my-terraform-state-key"
#     region = "us-west-2"
#   }
# }
