output "lambda_function_name" {
  value = aws_lambda_function.app.function_name
}

output "secret_arn" {
  value = aws_secretsmanager_secret.db_creds.arn
}

output "test_command" {
  description = "Comando per testare come funziona il flusso. Assicurati che le risorse e la CLI siano nella stessa region oppure esplicitala!"
  value = "aws lambda invoke --function-name ${aws_lambda_function.app.function_name} response.json && cat response.json"
}