########################################
# Provider
########################################
provider "aws" {
  region = "ap-southeast-1"
}

########################################
# S3 Bucket for Terraform State
########################################
resource "aws_s3_bucket" "tf_state" {
  bucket = "group3-tfstate-dev"

  tags = {
    Name        = "group3-tfstate-dev"
    Environment = "dev"
  }
}

resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

########################################
# DynamoDB Table for State Locking
########################################
resource "aws_dynamodb_table" "tf_lock" {
  name         = "group3-tfstate-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "group3-tfstate-lock"
    Environment = "dev"
  }
}
