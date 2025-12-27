variable "project_name" {
    description = "Nome del progetto per tag etc."
    default     = "rbac-access-playground"
}

variable "environment" {
    description = "Ambiente di deploy per tag etc."
    default     = "Dev"
}

variable "pgp_key" {
  description = "Inserisci la tua chiave pubblica (base64) o keybase:username"
  type        = string
}