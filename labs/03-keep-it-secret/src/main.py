import boto3
import json
import os
import logging
from botocore.exceptions import ClientError

logger = logging.getLogger()
logger.setLevel(logging.INFO)

try:
    client = boto3.client('secretsmanager')
except Exception as e:
    logger.error(f"ERRORE: fallimento init Secret Manager : {str(e)}")
    raise e

def handler(event, context):
    secret_name = os.environ.get('SECRET_NAME') # la region è specificata nell'invoke, rom
    
    if not secret_name:
        logger.error("Environment variable SECRET_NAME is missing")
        raise ValueError("SECRET_NAME environment variable is not defined")

    logger.info(f"Retrieving secret: {secret_name}")

    try:
        # get password da aws
        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )
    except Exception as e:
        logger.error(f"Errore nel recupero del segreto: {e}")
        raise e

    # decode del secret
    if 'SecretString' in get_secret_value_response:
        secret = get_secret_value_response['SecretString']
        logger.error("Segreto recuperato con successo!")
        
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