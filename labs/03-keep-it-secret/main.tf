# Generiamo una password casuale complessa
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

# Creiamo il "contenitore" in Secrets Manager
resource "aws_secretsmanager_secret" "db_creds" {
  name        = "${var.project_name}-db-creds-${random_id.suffix.hex}"
  description = "Credenziali database per Lab 03"
}

# Qui inseriamo il valore effettivo 
resource "aws_secretsmanager_secret_version" "db_creds_val" {
  secret_id     = aws_secretsmanager_secret.db_creds.id
  secret_string = jsonencode({
    username = "admin"
    password = random_password.db_password.result
    engine   = "mysql"
  })
}

resource "random_id" "suffix" {
  byte_length = 4
}


# IAM per la lambda, dovresti sapere già cosa è un ruolo!

resource "aws_iam_role" "lambda_exec" {
  name = "${var.project_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

# Permessi base (esecuzione e log su CloudWatch)
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Permettiamo di leggere SOLO il nostro segreto, aderendo al principio di Least Privilage

resource "aws_iam_policy" "secrets_policy" {
  name = "${var.project_name}-read-policy"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "secretsmanager:GetSecretValue"
      Resource = aws_secretsmanager_secret.db_creds.arn # <-- Solo questo ARN!
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_secrets" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.secrets_policy.arn
}


# Config della lambda

# Zippa il codice Python
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/src/main.py"
  output_path = "${path.module}/lambda_payload.zip"
}

resource "aws_lambda_function" "app" {
  filename      = data.archive_file.lambda_zip.output_path
  function_name = "${var.project_name}-app"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "main.handler"
  runtime       = "python3.12"

  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  # Passiamo il NOME (non il VALORE sennò non ha senso) del segreto come variabile d'ambiente
  environment {
    variables = {
      SECRET_NAME = aws_secretsmanager_secret.db_creds.name
    }
  }
}