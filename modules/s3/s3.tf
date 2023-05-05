variable "ENV" {}

resource "aws_s3_bucket" "toktokhan-test-bucket" {
  bucket = "toktokhan-test-${var.ENV}-bucket"

  tags = {
    Iac  = "Terraform"
    ENV  = var.ENV
    Name = "toktokhan-test-${var.ENV}-s3"
  }
}

resource "aws_s3_bucket_ownership_controls" "toktokhan-test-bucket_ownership_controls" {
  bucket = aws_s3_bucket.toktokhan-test-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "toktokhan-test-bucket-public-acl" {
  depends_on = [aws_s3_bucket_ownership_controls.toktokhan-test-bucket_ownership_controls]

  bucket = aws_s3_bucket.toktokhan-test-bucket.id
  acl    = "public-read-write"
}

resource "aws_s3_bucket_versioning" "toktokhan-test-bucket_versioning" {
  bucket = aws_s3_bucket.toktokhan-test-bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# SSE 암호화
resource "aws_s3_bucket_server_side_encryption_configuration" "toktokhan-test-bucket_sse_config" {
  bucket = aws_s3_bucket.toktokhan-test-bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}