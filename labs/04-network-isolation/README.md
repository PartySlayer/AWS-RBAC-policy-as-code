# 🏰 Lab 04: Network Isolation & VPC Endpoints

> **Obiettivo:** Implementare una strategia "Zero Trust Network" dove i dati su S3 sono accessibili **SOLO** dall'interno della rete privata (VPC), rendendo inutili eventuali credenziali rubate usate dall'esterno.

Le credenziali IAM (Access Keys) possono essere rubate.  
Se un attaccante ottiene le chiavi di un Admin, può scaricare i dati da qualsiasi luogo (casa sua, un server pubblico, ecc.).  
La sola autenticazione (Identity) non basta per proteggere i dati critici: serve anche il perimetro di rete.

## 🛡️ La Soluzione: VPC Endpoint & Bucket Policy

Usiamo un **VPC Gateway Endpoint** per creare un "tunnel" privato tra la nostra VPC e S3.  
Configuriamo poi una **Bucket Policy** con una condizione `Deny` esplicita: se la richiesta non proviene da *questo* specifico Endpoint, viene rifiutata.  
A prescindere da chi sei (anche se sei Admin!).

## 🏗️ Architettura

<img width="1202" height="782" alt="network-isolation" src="https://github.com/user-attachments/assets/3276e0ca-aafc-4239-bc6a-1655e4d350ca" />  

---

1. **VPC & Subnet:** Una rete privata isolata (con una Subnet Pubblica per l'accesso di gestione).
2. **VPC Endpoint (S3):** Un collegamento che instrada il traffico S3 internamente alla rete AWS, senza passare da Internet pubblico.
3. **Bucket Policy "Fortress":** Blocca tutto il traffico che non soddisfa la condizione `aws:SourceVpce`.
4. **EC2 Tester:** Un'istanza che vive nella rete autorizzata per dimostrare l'accesso.

## 🚀 Test per validare

La validazione richiede due passaggi per dimostrare che la rete blocca l'intruso e lascia passare l'autorizzato.

1. **Deploya l'infrastruttura**

    ```bash
    terraform apply
    ```

    *(Annota il nome del bucket dall'output)*

2. **Test 1: L'Attacco Esterno (Fallimento Atteso)**
    Dal tuo terminale locale (dove sei Admin, ma fuori dalla VPC), prova a listare i file:

    ```bash
    aws s3 ls s3://<IL_TUO_BUCKET_NAME>
    ```

    **Risultato:** Riceverai `Access Denied`. La policy ti ha bloccato perché il tuo IP non passa dal tunnel.

3. **Test 2: L'Accesso Interno (Successo ✅)**
    * Vai sulla Console AWS > **EC2**.
    * Seleziona l'istanza `lab04-network-vm` e clicca **Connect** (usa EC2 Instance Connect).
    * Nel terminale web che si apre, lancia lo stesso comando:

    ```bash
    aws s3 ls s3://<IL_TUO_BUCKET_NAME>
    ```

    **Risultato:** Vedrai la lista dei file (o nessuna errore se vuoto). Sei passato dal VPC Endpoint!

## 🧹 Cleanup

   ```bash
    terraform destroy
