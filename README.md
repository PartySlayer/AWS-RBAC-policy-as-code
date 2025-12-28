# POLICY AS CODE

## IaC + IAM = policy-as-code

Questo progetto nasce dalla necessità di simulare una gestione degli accessi Enterprise-Grade su AWS, applicando i principi di sicurezza standard (Least Privilege, Zero Trust) e la Compliance automatizzata.

L'obiettivo è dimostrare come blindare le risorse critiche (S3) non solo tramite permessi statici, ma attraverso condizioni di sicurezza dinamiche, come l'obbligo di autenticazione Multi-Factor (MFA) per le operazioni distruttive.

<img width="647" height="350" alt="image" src="https://github.com/user-attachments/assets/c0e5ecd6-92f1-462e-a996-61ecd530d1c8" />


## 🏗️ Architettura & Sicurezza

Il deployment è **completamente gestito tramite Terraform** e si poggia su tre pilastri:

* **S3 Hardening**: Bucket configurato con Server-Side Encryption (AES256) e Public Access Block attivo.

* **RBAC (Role-Based Access Control)**: Separazione netta tra profili Junior (Read-Only) e Senior (Write/Delete).

* **MFA Enforcement**: Una policy condizionale che nega esplicitamente le azioni di scrittura ai profili Senior se non è presente un token MFA attivo nella sessione.

## 🛠️ Tech Stack

Infrastructure as Code: Terraform

Cloud Provider: AWS (IAM, S3)

Security Tools: IAM Policy Conditions, MFA, Global Condition Keys
