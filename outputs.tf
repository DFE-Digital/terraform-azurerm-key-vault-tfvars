output "key_vault_key_id" {
  description = "The Key Vault Key ID"
  value       = local.generate_key_vault_key ? azurerm_key_vault_key.generated[0].id : ""
}
