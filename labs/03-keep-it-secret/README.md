# 🤐 Lab 03: Secrets Management (No Hardcoded Passwords)

> **Obiettivo:** Gestire credenziali sensibili (Database Passwords, API Keys) senza mai scriverle nel codice sorgente o nelle variabili d'ambiente in chiaro.

<img width="1522" height="1062" alt="keep-it-secret" src="https://github.com/user-attachments/assets/1682e792-331d-4537-8ac8-04f3b04abd72" />

## 🧐 Il Problema

Le password hardcodate sono la causa #1 di Data Breach.
Anche usare variabili d'ambiente standard (`DB_PASSWORD=123`) è rischioso, perché sono visibili nella console AWS in chiaro.

## 🛡️ La Soluzione: AWS Secrets Manager

In questo lab, Terraform genera una password casuale e la deposita direttamente in **AWS Secrets Manager**.
L'applicazione (Lambda Python) conosce solo il *nome* del segreto, non il *valore*.
A runtime, interroga le API AWS per ottenere la password decifrata, usandola solo in memoria.

## 🏗️ Architettura

1. **Terraform:** Genera una stringa casuale (`random_password`) e crea il Secret.
2. **IAM Role:** Concede alla Lambda il permesso `secretsmanager:GetSecretValue` **solo** su quel segreto specifico.
3. **Lambda Function:**

    * Legge `os.environ['SECRET_NAME']`.
    * Chiama `boto3` per ottenere il valore.
    * Simula la connessione al DB.

## 🚀 Test per validare

1. Deploya l'infrastruttura

    ```bash
    terraform apply
    ```
2. Test (Invoke):
    Copia il comando di output (ricordati di aggiungere la region se necessario!):

    ```bash
    aws lambda invoke --function-name lab03-secrets-app --region eu-south-1 response.json && cat response.json
    ```
4. **Risultato:**
    Vedrai `"Connected to DB using password: ..."` senza aver mai configurato la password manualmente.

## 🧹 Cleanup

    ```bash
    terraform destroy
    ```
