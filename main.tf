module "s3_secure_storage" {
  source = "./modules/s3"

  bucket_prefix = "linkedin-sysops-demo"
  
  tags = {
    Environment = "Dev"
    Project     = "RBAC-Playground"
    ManagedBy   = "Terraform"
  }
}