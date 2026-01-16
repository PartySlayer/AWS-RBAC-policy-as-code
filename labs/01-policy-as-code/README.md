# POLICY AS CODE

## IaC + IAM = policy-as-code

> **Obiettivo:** dimostrare come blindare le risorse critiche (S3) non solo tramite permessi statici, ma attraverso condizioni di sicurezza dinamiche, come l'obbligo di autenticazione Multi-Factor (MFA) per le operazioni distruttive.

<img width="649" height="352" alt="image" src="https://github.com/user-attachments/assets/fcb18f8d-de98-4a58-a296-dbafebb34022" />

## 🏗️ Architettura & Sicurezza

<img width="671" height="541" alt="iam-s3" src="https://github.com/user-attachments/assets/ffefcd71-61de-43b1-b61f-a4511c10669e" />

---

Il deployment è **completamente gestito tramite Terraform** e si poggia su tre pilastri:

* **S3 Hardening**: Bucket configurato con Server-Side Encryption (AES256) e Public Access Block attivo.

* **RBAC (Role-Based Access Control)**: Separazione netta tra profili Junior (Read-Only) e Senior (Write/Delete).

* **MFA Enforcement**: Una policy condizionale che nega esplicitamente le azioni di scrittura ai profili Senior se non è presente un token MFA attivo nella sessione.


## 🚀 Test per validare

1. Deploya l'infrastruttura (assicurati di passare la tua chiave pubblica PGP per le password)::

    ```bash
    terraform apply -var="pgp_key=$(cat key.txt)"
    ```

2. Recupera le password **decifrandole** (output di Terraform):
```bash
terraform output -json passwords | jq -r .beatrice | base64 --decode | gpg --decrypt
```

3. Prova ad accedere come Beatrice (Senior) da CLI o Console AWS
4. Esegui un comando di scrittura senza MFA:

    ```bash
    aws s3 cp test.txt s3://<IL_TUO_BUCKET>
    ```
**❌ Risultato**: AccessDenied (La policy blocca la scrittura senza MFA).  

5. **Autenticati con MFA:**(GetSessionToken) e riprova:
   
✅ Risultato: Successo!

## 🧹 Cleanup

```bash
terraform destroy
```

### 🏁 Prossimo Step: Lab 02 (Roles Principle)

Sai che anche le risorse hanno bisogno di permessi specifici per ogni azione? Proprio come un utente ma per loro creiamo i **ruoli**. 
Vai a scoprirlo nel [**Lab 02: No more users**](../02-no-more-users)

