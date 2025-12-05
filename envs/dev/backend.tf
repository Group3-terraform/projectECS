terraform {
  backend "s3" {
    bucket         = "group3-tfstate-dev"
    key            = "dev/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "group3-tfstate-lock" 
  }
}
