data "azurerm_client_config" "current" {}

data "azuread_user" "key_vault_access" {
  for_each = local.key_vault_access_users

  user_principal_name = each.value
}

data "azurerm_resource_group" "existing_resource_group" {
  count = local.existing_resource_group == "" ? 0 : 1

  name = local.existing_resource_group
}

data "azurerm_logic_app_workflow" "monitor_logic_app_workflow" {
  count = local.monitor_logic_app_workflow.name == "" ? 0 : 1

  name                = local.monitor_logic_app_workflow.name
  resource_group_name = local.monitor_logic_app_workflow.resource_group_name
}
