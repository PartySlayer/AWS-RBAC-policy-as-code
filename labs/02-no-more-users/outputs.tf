output "ec2_instance_id" {
  description = "ID della macchina EC2"
  value       = aws_instance.web_server.id
}

output "bucket_name" {
  description = "Nome del bucket da testare"
  value       = module.s3_bucket.bucket_id
}