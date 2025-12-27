module "s3_secure_storage" {
  source = "./modules/s3"

  bucket_prefix = "rbac-access"
  
  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

module "iam_rbac" {
  source = "./modules/iam"

  bucket_arn = module.s3_secure_storage.bucket_arn
  
  project_name = var.project_name
}