# Usiamo i RUOLI (No More Users)

> **Obiettivo:** Eliminare le credenziali a lungo termine (Access Keys) dalle applicazioni e utilizzare credenziali temporanee tramite IAM Roles.

## 🧐 Il Problema

Nel [**Lab 01**](../01-policy-as-code), gli utenti (Alessandro/Beatrice) usavano user/password o access keys.
Ma quando un'applicazione (es. su EC2) deve accedere ad AWS, dove salviamo le credenziali?

* ❌ Nel codice? (Rischio Leak su GitHub)
* ❌ Nelle variabili d'ambiente? (Difficili da ruotare)
* ❌ In un file config? (Chi lo protegge?)

## 🛡️ La Soluzione: IAM Roles & Instance Profiles

Invece di dare un'identità alla macchina, le diamo un "Ruolo" che può assumere.
Le credenziali non vengono mai salvate su disco: sono generate dinamicamente dal **Metadata Service** di AWS e ruotate automaticamente ogni poche ore.

## 🏗️ Architecture

1. **EC2 Instance:** Una macchina virtuale, usiamo Amazon Linux 2023.
2. **Instance Profile:** Il contenitore che passa il ruolo alla EC2.
3. **Trust Policy:** Permette al servizio `ec2.amazonaws.com` di assumere il ruolo.
4. **Least Privilege:** Il ruolo ha accesso SOLO in lettura (`s3:ListBucket`, `s3:GetObject`) sul bucket specifico del lab.

## 🚀 Test per validare

1. Deploya l'infrastruttura:

    ```bash
    terraform apply
    ```

2. Connettiti alla EC2 via **Instance Connect** (dalla Console AWS).
3. Esegui il comando AWS CLI (senza mai aver fatto `aws configure`!):

    ```bash
    aws s3 ls s3://<IL_TUO_BUCKET_NAME>
    ```

4. **Risultato:** Funziona! AWS ha iniettato le credenziali temporanee per te.

## 🧹 Cleanup

```bash
terraform destroy
