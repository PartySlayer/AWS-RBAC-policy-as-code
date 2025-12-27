output "bucket_arn" {
  description = "ARN del bucket creato"
  value       = aws_s3_bucket.secure_bucket.arn
}

output "bucket_id" {
  description = "ID (Nome) del bucket creato"
  value       = aws_s3_bucket.secure_bucket.id
}