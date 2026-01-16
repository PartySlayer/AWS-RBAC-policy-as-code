# ☁️ AWS IAM & Security Labs

> **Un percorso progressivo all'interno dei servizi AWSdi  Identity, Access Management, e Security Operations via Terraform.**

In questa raccolta di laboratori pratici, affrontiamo diversi scenari di sicurezza reali, partendo dalle basi fino a configurazioni avanzate.

L'approccio è **Infrastructure as Code (IaC)**: ogni scenario è completamente riproducibile e autodocumentato.

## 🧪 Laboratori Disponibili

| Livello | Lab ID | Titolo | Focus Tecnico | Stato |
| :---: | :--- | :--- | :--- | :--- |
| 🟢 | **01** | [**Policy-as-code**](./labs/01-policy-as-code) | IAM Users, Groups, MFA Enforcement, S3 Encryption, PGP Secrets | ✅ Completato |
| 🟡 | **02** | [**The Role Principle**](./labs/02-no-more-users) | Eliminare gli IAM Users, EC2 Instance Profiles, `sts:AssumeRole` | ✅ Completato |
| 🟡 | **03** | [**Secrets**](./labs/03-keep-it-secret) | AWS Secrets Manager, KMS, VPC Endpoints & Bucket Policies |✅ Completato|
| 🔴 | **04** | **Network Isolation** | AWS Secrets Manager, KMS, VPC Endpoints & Bucket Policies | 🔒 Locked |

## 🛠️ Tech Stack Globale

* **Cloud Provider & Core Tech:** AWS, AWS CLI, Terraform
* **Security:** GPG/PGP, IAM Policy Simulator, RBAC, Roles vs Users, Secrets management
* **Architecture:** Modular Design (DRY)
