# Genera un suffisso casuale per garantire l'univocità del nome

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "secure_bucket" {
  bucket = "${var.bucket_prefix}-${random_id.bucket_suffix.hex}"
  tags   = var.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.secure_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_block" {
  bucket = aws_s3_bucket.secure_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}