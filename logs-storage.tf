resource "azurerm_storage_account" "logs" {
  count = local.enable_diagnostic_storage_account ? 1 : 0
  #checkov:skip=CKV_AZURE_33: Ensure Storage logging is enabled for Queue service for read, write and delete requests
  #checkov:skip=CKV_AZURE_206: Ensure that Storage Accounts use replication
  #checkov:skip=CKV2_AZURE_1: Ensure storage for critical data are encrypted with Customer Managed Key
  #checkov:skip=CKV2_AZURE_33: Ensure storage account is configured with private endpoint
  name                            = "${replace(local.resource_prefix, "-", "")}tfvarslogs"
  resource_group_name             = local.resource_group.name
  location                        = local.resource_group.location
  account_tier                    = "Standard"
  account_kind                    = "StorageV2"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  https_traffic_only_enabled      = true
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = true

  #checkov:skip=CKV2_AZURE_40: Ensure storage account is not configured with Shared key authorization
  sas_policy {
    expiration_period = "2.00:00:00"
  }

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }

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
