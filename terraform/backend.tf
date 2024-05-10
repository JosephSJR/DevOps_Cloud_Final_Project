terraform {
  backend "s3" {
    bucket = "final-project-tf-state"
    key    = "terraform.tfstate"
    region = "us-east-1"
    workspace_key_prefix = "joseph"
    dynamodb_table = "terraform-lock-epam"
  }
}