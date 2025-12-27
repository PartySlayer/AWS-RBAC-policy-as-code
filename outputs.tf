output "s3_bucket_name" {
  value = module.s3_secure_storage.bucket_id
}

output "passwords" {
    description = "Password degli utenti cifrate"
    value       = {
    alessandro  = module.iam_rbac.alessandro_password_encrypted
    beatrice    = module.iam_rbac.beatrice_password_encrypted
  }
}