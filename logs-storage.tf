resource "azurerm_storage_account" "logs" {
  count = local.enable_diagnostic_storage_account ? 1 : 0

  name                            = "${replace(local.resource_prefix, "-", "")}tfvarslogs"
  resource_group_name             = local.resource_group.name
  location                        = local.resource_group.location
  account_tier                    = "Standard"
  account_kind                    = "StorageV2"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  enable_https_traffic_only       = true
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = false

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
