variable "bucket_prefix" {
  description = "Prefisso del nome del bucket (deve essere univoco globalmente)"
  type        = string
}

variable "tags" {
  description = "Tags da applicare alle risorse"
  type        = map(string)
  default     = {}
}