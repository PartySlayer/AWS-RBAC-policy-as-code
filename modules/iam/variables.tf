variable "bucket_arn" {
  description = "L'ARN del bucket S3 a cui dare accesso"
  type        = string
}

variable "project_name" {
  description = "Nome del progetto per taggare le risorse"
  type        = string
  default     = "rbac-playground"
}

