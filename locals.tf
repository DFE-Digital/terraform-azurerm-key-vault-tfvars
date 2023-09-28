locals {
  environment                 = var.environment
  project_name                = var.project_name
  existing_resource_group     = var.existing_resource_group
  azure_location              = var.azure_location
  resource_prefix             = "${local.environment}${local.project_name}"
  resource_group              = local.existing_resource_group == "" ? azurerm_resource_group.default[0] : data.azurerm_resource_group.existing_resource_group[0]
  enable_resource_group_lock  = var.enable_resource_group_lock
  key_vault_access_users      = toset(var.key_vault_access_users)
  key_vault_access_ipv4       = var.key_vault_access_ipv4
  key_vault_access_subnet_ids = var.key_vault_access_subnet_ids
  generate_key_vault_key      = var.generate_key_vault_key
  encrypt_tfvars              = var.encrypt_tfvars
  key_vault_key_permissions = local.generate_key_vault_key ? [
    "Create",
    "Delete",
    "Get",
    "Purge",
    "List",
    "Backup",
    "Restore",
    "Recover",
    "Update",
    "Decrypt",
    "Encrypt",
    "Verify",
    "Rotate",
    "SetRotationPolicy",
    "GetRotationPolicy",
  ] : []
  tfvars_filename                    = var.tfvars_filename
  enable_diagnostic_setting          = var.enable_diagnostic_setting
  enable_diagnostic_storage_account  = var.diagnostic_storage_account_id == "" ? var.enable_diagnostic_storage_account : false
  enable_log_analytics_workspace     = var.diagnostic_log_analytics_workspace_id == "" ? var.enable_log_analytics_workspace : false
  enable_diagnostic_retention_policy = var.enable_diagnostic_retention_policy
  diagnostic_retention_days          = var.diagnostic_retention_days
  diagnostic_log_analytics_workspace_id = var.diagnostic_log_analytics_workspace_id != "" ? var.diagnostic_log_analytics_workspace_id : (
    local.enable_log_analytics_workspace ? azurerm_log_analytics_workspace.key_vault[0].id : null
  )
  log_analytics_destination_type = var.diagnostic_log_analytics_workspace_id != "" || local.enable_log_analytics_workspace ? "Dedicated" : null
  diagnostic_storage_account_id = var.diagnostic_storage_account_id != "" ? var.diagnostic_storage_account_id : (
    local.enable_diagnostic_storage_account ? azurerm_storage_account.logs[0].id : null
  )
  diagnostic_eventhub_name = var.diagnostic_eventhub_name != "" ? var.diagnostic_eventhub_name : null
  tags                     = var.tags
  secret_expiry_years      = var.secret_expiry_years
  timestamp_parts          = regex("^(?P<year>\\d+)(?P<remainder>-.*)$", timestamp())
  year_from_now            = format("%d%s", local.timestamp_parts.year + local.secret_expiry_years, local.timestamp_parts.remainder)
}
