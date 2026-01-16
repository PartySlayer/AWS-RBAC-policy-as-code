import boto3
import json
import os

def handler(event, context):
    secret_name = os.environ['SECRET_NAME']
    region_name = os.environ['AWS_REGION']

    # Crea un client per Secrets Manager
    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name
    )

    try:
        # get password da aws
        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )
    except Exception as e:
        print(f"Errore nel recupero del segreto: {e}")
        raise e

    # decode del secret
    if 'SecretString' in get_secret_value_response:
        secret = get_secret_value_response['SecretString']
        print("Segreto recuperato con successo!")
        
        # In uno scenario reale, questo non accade ma...
        # Qui lo stampiamo parzialmente solo per demo (NON FARLO IN PROD!)

        secret_dict = json.loads(secret)
        masked_pwd = secret_dict['password'][:2] + "*" * 5
        return {
            'statusCode': 200,
            'body': json.dumps(f"Connected to DB using password: {masked_pwd}")
        }
    else:
        return {'statusCode': 500, 'body': "Segreto non trovato o binario"}