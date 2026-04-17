resource "azurerm_storage_account" "logs" {
  count = local.enable_diagnostic_storage_account ? 1 : 0
  #checkov:skip=CKV_AZURE_59: Suppressing check pending review
  #checkov:skip=CKV_AZURE_33: Suppressing check pending review
  #checkov:skip=CKV_AZURE_190: Suppressing check pending review
  #checkov:skip=CKV_AZURE_206: Suppressing check pending review
  #checkov:skip=CKV2_AZURE_41: Suppressing check pending review
  #checkov:skip=CKV2_AZURE_38: Suppressing check pending review
  #checkov:skip=CKV2_AZURE_40: Suppressing check pending review
  #checkov:skip=CKV2_AZURE_1: Suppressing check pending review
  #checkov:skip=CKV2_AZURE_47: Suppressing check pending review
  #checkov:skip=CKV2_AZURE_33: Suppressing check pending review
  name                       = "${replace(local.resource_prefix, "-", "")}tfvarslogs"
  resource_group_name        = local.resource_group.name
  location                   = local.resource_group.location
  account_tier               = "Standard"
  account_kind               = "StorageV2"
  account_replication_type   = "LRS"
  min_tls_version            = "TLS1_2"
  https_traffic_only_enabled = true

  tags = local.tags
}

resource "azurerm_storage_account_network_rules" "logs" {
  count = local.enable_diagnostic_storage_account ? 1 : 0

  storage_account_id         = azurerm_storage_account.logs[0].id
  default_action             = "Deny"
  bypass                     = ["AzureServices"]
  virtual_network_subnet_ids = []
  ip_rules                   = []
}
