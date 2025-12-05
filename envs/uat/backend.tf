terraform {
  backend "s3" {
    bucket         = "group3-tfstate-uat"
    key            = "ecs/uat/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "group3-tfstate-lock"
    encrypt        = true
  }
}
