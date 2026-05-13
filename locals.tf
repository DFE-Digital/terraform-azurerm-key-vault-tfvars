locals {
  environment                             = var.environment
  project_name                            = var.project_name
  existing_resource_group                 = var.existing_resource_group
  azure_location                          = var.azure_location
  resource_prefix                         = "${local.environment}${local.project_name}"
  resource_group                          = local.existing_resource_group == "" ? azurerm_resource_group.default[0] : data.azurerm_resource_group.existing_resource_group[0]
  enable_resource_group_lock              = var.enable_resource_group_lock
  key_vault_access_users                  = toset(var.key_vault_access_users)
  key_vault_access_ipv4                   = var.key_vault_access_ipv4
  key_vault_access_subnet_ids             = var.key_vault_access_subnet_ids
  key_vault_access_use_rbac_authorization = var.key_vault_access_use_rbac_authorization
  tfvars_filename                         = var.tfvars_filename
  enable_tfvars_file_age_check            = var.enable_tfvars_file_age_check
  enable_diagnostic_setting               = var.enable_diagnostic_setting
  enable_diagnostic_storage_account       = var.diagnostic_storage_account_id == "" ? var.enable_diagnostic_storage_account : false
  enable_log_analytics_workspace          = var.diagnostic_log_analytics_workspace_id == "" ? var.enable_log_analytics_workspace : false
  enable_private_endpoint                 = var.enable_private_endpoint
  virtual_network_id                      = var.virtual_network_id
  virtual_network_name                    = var.virtual_network_name
  key_vault_subnet_cidr                   = var.key_vault_subnet_cidr
  diagnostic_log_analytics_workspace_id = var.diagnostic_log_analytics_workspace_id != "" ? var.diagnostic_log_analytics_workspace_id : (
    local.enable_log_analytics_workspace ? azurerm_log_analytics_workspace.key_vault[0].id : null
  )
  log_analytics_destination_type = var.diagnostic_log_analytics_workspace_id != "" || local.enable_log_analytics_workspace ? "Dedicated" : null
  diagnostic_storage_account_id = var.diagnostic_storage_account_id != "" ? var.diagnostic_storage_account_id : (
    local.enable_diagnostic_storage_account ? azurerm_storage_account.logs[0].id : null
  )
  diagnostic_eventhub_name                = var.diagnostic_eventhub_name != "" ? var.diagnostic_eventhub_name : null
  enable_monitoring                       = var.enable_monitoring && local.enable_log_analytics_workspace
  monitor_email_receivers                 = var.monitor_email_receivers
  monitor_logic_app_workflow              = var.monitor_logic_app_workflow
  monitor_logic_app_workflow_name         = local.monitor_logic_app_workflow.name == "" ? "" : data.azurerm_logic_app_workflow.monitor_logic_app_workflow[0].name
  monitor_logic_app_workflow_id           = local.monitor_logic_app_workflow.name == "" ? "" : data.azurerm_logic_app_workflow.monitor_logic_app_workflow[0].id
  monitor_logic_app_workflow_callback_url = local.monitor_logic_app_workflow.name == "" ? "" : data.azapi_resource_action.monitor_logic_app_workflow[0].output.value
  tags                                    = var.tags
  secret_expiry_years                     = var.secret_expiry_years
  timestamp_parts                         = regex("^(?P<year>\\d+)(?P<remainder>-.*)$", timestamp())
  year_from_now                           = format("%d%s", local.timestamp_parts.year + local.secret_expiry_years, local.timestamp_parts.remainder)

  is_windows = can(regex("^[A-Za-z]:", abspath(path.root)))
  bash       = local.is_windows ? "C:/Program Files/Git/bin/bash.exe" : "/bin/bash"
}
