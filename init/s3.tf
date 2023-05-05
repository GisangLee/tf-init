// Remote backend용 s3
resource "aws_s3_bucket" "tfstate-bucket" {
  bucket = "tfstate-bucket"
}

resource "aws_s3_bucket_versioning" "tfstate-bucket_versioning" {
  bucket = aws_s3_bucket.tfstate-bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}