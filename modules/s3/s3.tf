variable "ENV" {}
variable "PROJECT_NAME" {}

resource "aws_s3_bucket" "bucket" {
  bucket = "${var.PROJECT_NAME}-${var.ENV}-bucket"

  tags = {
    Iac  = "Terraform"
    ENV  = var.ENV
    Name = "${var.PROJECT_NAME}-${var.ENV}-s3"
  }
}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership_controls" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "bucket-public-acl" {
  depends_on = [aws_s3_bucket_ownership_controls.bucket_ownership_controls]

  bucket = aws_s3_bucket.bucket.id
  acl    = "public-read-write"
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# SSE 암호화
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_sse_config" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}