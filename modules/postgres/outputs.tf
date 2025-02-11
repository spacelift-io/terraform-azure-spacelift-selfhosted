output "postgres_password" {
  sensitive = true
  value = random_password.db-root-password.result
}