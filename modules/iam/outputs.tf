output "junior_user_name" {
  description   = "Username utente Junior"
  value         = aws_iam_user.alessandro.name
}

output "senior_user_name" {
  description   = "Username utente Senior"
  value         = aws_iam_user.beatrice.name
}

output "alessandro_password_encrypted" {
  description   = "Password cifrata PGP per Alessandro"
  value         = aws_iam_user_login_profile.alessandro_login.encrypted_password
}

output "beatrice_password_encrypted" {
  description   = "Password cifrata PGP per Beatrice"
  value         = aws_iam_user_login_profile.beatrice_login.encrypted_password
}