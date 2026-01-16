# Usiamo i RUOLI (No More Users)

> **Obiettivo:** Eliminare le credenziali a lungo termine (Access Keys) e utilizzare credenziali temporanee tramite IAM Roles.

<img width="1143" height="723" alt="no-more-users" src="https://github.com/user-attachments/assets/093dbe16-9540-494f-98bd-0c0f3a5941ce" />
git a
## 🧐 Il Problema

Nel [**Lab 01**](../01-policy-as-code), gli utenti (Alessandro/Beatrice) usavano user/password o access keys.
Ma quando un'applicazione (es. su EC2) deve accedere ad AWS, dove salviamo le credenziali?

* ❌ Nel codice? (Rischio Leak su GitHub)
* ❌ Nelle variabili d'ambiente? (Difficili da ruotare)
* ❌ In un file config? (Chi lo protegge?)

## 🛡️ La Soluzione: IAM Roles & Instance Profiles

Invece di dare un'identità alla macchina, le diamo un "Ruolo" che può assumere.
Le credenziali non vengono mai salvate su disco: sono generate dinamicamente dal **Metadata Service** di AWS e ruotate automaticamente ogni poche ore.

## 🏗️ Architettura

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
```

### 🏁 Prossimo Step: Lab 03 (Secrets & Lambda)

Con il Lab 02 hai messo in sicurezza le **Compute Resources**.
Ma cosa succede se la tua app ha bisogno di una password per un Database esterno o una API Key di terze parti? Quelle non le gestisce IAM.

Nel [**Lab 03**](../03-keep-it-secret/), alzeremo l'asticella:

* Creeremo un **Secret** in AWS Secrets Manager (generato da Terraform).
* Useremo una **Lambda Function** (Python) per recuperarlo a runtime.
* Dimostreremo che nessuno (nemmeno lo sviluppatore) deve conoscere la password reale.

Sei pronto a sporcarti le mani con un po' di Python e Lambda? 🐍
